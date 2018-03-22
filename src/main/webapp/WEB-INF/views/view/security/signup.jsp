<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page session="true"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id" content="934878702971-vhv1inbu6cg8m4cggh4itr8mfuuidoo9.apps.googleusercontent.com">
    <title>Shuttle Bus Management</title>

    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <spring:url value="/resources/Bootstrap/css/style.css" var="loginStyle"/>
    <link rel="stylesheet"  type="text/css" href="${loginStyle}">
    <script src="https://code.jquery.com/jquery-3.0.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.js"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>


    <!-- Bootstrap Core JavaScript -->
    <spring:url value="/resources/Bootstrap/js/bootstrap.min.js" var="JSCORE"/>
    <script src="${JSCORE}"></script>



    <spring:url value="/resources/Bootstrap/css/sweetalert.css" var="alertStyle"/>
    <spring:url value="/resources/Bootstrap/js/sweetalert.min.js" var="alertJS"/>
    <spring:url value="/resources/css/radio.css" var="Radio"/>
    <link rel="stylesheet" type="text/css" href="${Radio}">
    <style>
        .form input,.form{
            border-radius: 5px;

        }
        form{
            text-align: left;
        }
        label.error{
            font-size: 12px;
            color:#e74c3c;
        }
        input[type="submit"]{
            cursor: pointer;
        }
        .switch{
            border-spacing: 0;
            width: 100%;
            text-align: center;
        }
        .switch td{
            padding: 20px;
            font-size: 17px;
            font-weight: bold;
            cursor: pointer;

            color:#7f8c8d;
        }
        .formdev{
            padding: 45px;
            padding-top: 0px;
        }
        .title-header{
            color:#636e72;
            font-size: 31px;
            margin-top: 35px;
        }
        .active-btn{
            background-color: #95a5a6;
            color:white !important;
            -webkit-transition: background-color 0.6s;
            transition: background-color 0.6s;
        }
        .active-btn:hover{
            background-color: #bdc3c7;
        }



    </style>
</head>
<body style="background: linear-gradient(to left, #636e72, #636e72);">
<div class="login-page">

    <ul class="form" style="padding: 0;padding-top:0px">
        <table class="switch">
            <tr>
                <td id="signin-btn" style="border-top-left-radius: 4px">SIGN IN</td>
                <td id="signup-btn" style="border-top-right-radius: 4px">SIGN UP</td>
            </tr>
        </table>
        <div class="formdev">
            <h1 class="title-header">vKIRIROM SHUTTLE BUS</h1>
            <form id="signup" action="<c:url value='/signup' />" method="post">
                <label for="email"></label>
                <input type='text'placeholder="Email" name='email' id="email">
                <input type="password" placeholder="Password" name="pass"  id="pass" autocomplete="new-password">
                <input type='text'placeholder="Username" name='username' id="username">
                <input type='text'placeholder="Phone" name="phone" id="phone">



                <input type="submit" style="background-color: #636e72;color:white;color:white;font-size: 14px;font-weight: bold"
                       value="SIGNUP">

            </form>
            <form class="login-form" id="loginform" action="<c:url value='/login' />" method="post">
                <input type='text'placeholder="Username" name='username' id="username" required>
                <input type="password" placeholder="Password" name="password" autocomplete="new-password" required/>
                <input type="submit" value="Login"
                       style="background-color: #636e72;color:white;color:white;font-size: 14px;font-weight: bold">
                <div style="font-size:10px;">
                    <a href ="signup" data-toggle="modal" data-target="#myModal">Forgot Password?</a>

                </div>
                <div class="g-signin2" data-onsuccess="onSignIn" data-theme="dark"></div>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            </form>
        </div>

</ul>


</div>

<input type="hidden" id="csrfToken" value="${_csrf.token}"/>
<input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>
</body>
<script type="text/javascript">

    $("#signup").hide();
    $("#signin-btn").addClass('active-btn');
    $("#signup-btn").click(function () {
        $("#signup-btn").addClass('active-btn');
        $("#signin-btn").removeClass('active-btn');
        $("#signup").slideDown(300)
        $("#loginform").hide();


    })

    $("#signin-btn").click(function () {
        $("#signin-btn").addClass("active-btn");
        $("#signup-btn").removeClass("active-btn");
        $("#loginform").slideDown(300)
        $("#signup").hide()


    })

    $(function() {
        $("#signup").validate({

            rules: {
                email: {
                    required: true,

                    email: true
                },
                pass: {
                    required: true,
                    minlength: 8
                },
                username: {
                    required: true,
                    minlength: 3
                },
                name: {
                    required: true,
                    minlength: 3
                },
                phone: {
                    required: true,
                    minlength: 9,
                    number:true
                }
            },
            messages: {
                email: {
                    required: "email is required",
                    email: "invalid email"
                },username: {
                    required: "username is required",
                    minlength: "username must be at least 3 characters long"
                },
                pass: {
                    required: "password is required",
                    minlength: "password must be at least 8 characters long"
                },
                name: {
                    required: "name is required",
                    minlength: "name must be at least 3 characters long"
                },
                phone: {
                    required: "phone is required",
                    minlength: "invalid phone number"
                },

            },

            submitHandler: function (form) {

                var token = $('#csrfToken').val();
                var header = $('#csrfHeader').val();
                var username = $('#username').val();
                var name = $('#name').val()
                var email = $('#email').val()
                var phone = $('#phone').val()
                var password = $('#pass').val();
                var gender = $("input[name='gender']:checked").val();
                console.log(password)
                axios.defaults.headers.common[header] = token;
                axios.post('signup', {
                    email: email,
                    password: password,
                    username:username,
                    gender:gender,
                    name:name,
                    phone:phone
                })
                    .then(function (response) {
                        if(response.data.status){
                            window.location.replace("login")
                        }

                    })
                    .catch(function (error) {
                        console.log(error);
                    });


                return false;
                //form.submit();
            }
        });
    });



    function googleSignin(data){
        axios({
            method: 'post',
            url: 'login',
            data: data
        })
            .then(function (response) {
                console.log(response)
                var url = response.request.responseURL;
                if(!url.includes("login")){
                    window.location.replace(url);
                }

            })
            .catch(function (error) {
                console.log(error);
            });
    }
    function onSignIn(googleUser) {
        var profile = googleUser.getBasicProfile();
        console.log(profile.getEmail())
        var auth2 = gapi.auth2.getAuthInstance();
        auth2.disconnect();
        axios.post('check_signup', {
            email: profile.getEmail(),
            password: profile.getId(),
            username:profile.getName(),
            name:profile.getGivenName(),
            profile:profile.getImageUrl()
        })
            .then(function (response) {
                if(response.data.status){
                    data = 'username='+profile.getEmail()+"--google" + '&password='+profile.getId()
                }

                googleSignin(data);
            })
            .catch(function (error) {
                console.log(error);
            });

    };




</script>
</html>
