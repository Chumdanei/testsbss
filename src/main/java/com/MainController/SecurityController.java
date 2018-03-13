package com.MainController;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.DaoClasses.userDaoImpl;
import com.DaoClasses.usersDao;
import com.EntityClasses.User_Info;
import com.ModelClasses.UserModel;

@Controller
public class SecurityController {

	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String defaultPage() {

		ModelAndView model = new ModelAndView();
		
		model.setViewName("project");

		 Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	
		 UserDetails userDetails=(UserDetails) auth.getPrincipal();
		 
		 Map<String ,Object> role= new HashMap<String ,Object>();
		 role.put("role1",userDetails.getAuthorities());
		 Object role2=(Object) role.get("role1");
		 StringBuffer userRole=new StringBuffer(role2.toString());
		 System.out.print(userRole);
		 if ("[ROLE_ADMIN]".contentEquals(userRole))
		 {
			 return "redirect:current_schedule";
		 }
		 if ("[ROLE_CUSTOMER]".contentEquals(userRole))
		 {
			 return "redirect:customer_home";
		 }
		return "redirect:login";

	}


	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public ModelAndView login(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout, HttpServletRequest request) {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		 UserDetails userDetails=(UserDetails) auth.getPrincipal();
		 
		 Map<String ,Object> role= new HashMap<String ,Object>();
		 role.put("role1",userDetails.getAuthorities());
		 Object role2=(Object) role.get("role1");
		 StringBuffer userRole=new StringBuffer(role2.toString());
		 
		ModelAndView model = new ModelAndView();
		
		 if ("[ROLE_ADMIN]".contentEquals(userRole))
		 {
			 model.setViewName("redirect:current_schedule");
			 return model;
		 }
		 if ("[ROLE_CUSTOMER]".contentEquals(userRole))
		 {
			 model.setViewName("redirect:customer_home");
			 return model;
		 }
		 
		if (error != null) {
			model.addObject("error", getErrorMessage(request, "SPRING_SECURITY_LAST_EXCEPTION"));
		}

		if (logout != null) {
			model.addObject("msg", "You've been logged out successfully.");
		}
		model.setViewName("security/login");

		return model;

	}

	// customize the error message
	private String getErrorMessage(HttpServletRequest request, String key) {

		Exception exception = (Exception) request.getSession().getAttribute(key);

		String error = "";
		if (exception instanceof BadCredentialsException) {
			error = "Invalid username and password!";
		} else if (exception instanceof LockedException) {
			error = exception.getMessage();
		} else {
			error = "Invalid username and password!";
		}

		return error;
	}
	

	// for 403 access denied page
	@RequestMapping(value = "/403", method = RequestMethod.GET)
	public ModelAndView accesssDenied() {

		ModelAndView model = new ModelAndView();

		// check if user is login
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (!(auth instanceof AnonymousAuthenticationToken)) {
			UserDetails userDetail = (UserDetails) auth.getPrincipal();
			
			model.addObject("username", userDetail.getUsername());

		}
		model.setViewName("security/403");
		return model;

	}
	@RequestMapping(value = "/check_signup", method = RequestMethod.POST)
	@ResponseBody public Map<String,Object> checkSignup(@RequestBody UserModel user) {
		usersDao userdao = new userDaoImpl();
		boolean status = true;
		Map<String,Object> map = new HashMap<String,Object>();
		System.out.println("hello:"+user.getPassword());
		User_Info user_info = userdao.findByUserName(user.getEmail());
		
		if(user_info==null){
			status = userdao.createUser(user);
		}
		map.put("status", status);
		return map;

	}

}
