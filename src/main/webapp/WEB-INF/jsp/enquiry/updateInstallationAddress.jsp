<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon.css"/>


<script type="text/javaScript">
   function resize(){
	   document.getElementById("customerLogin").style.minHeight = screen.height  + 50 + "px";
       document.getElementById("customerLogin").style.minWeight = screen.weight +100 + "px";
   }

    window.addEventListener('resize', function(event){
    	resize();
	});

    $(function(){

    	resize();

        //hide footer
        let x = document.querySelector('.bottom_msg_box');
        x.style.display = "none";

        $('#btnSubmit').click(function(evt) {
                 let param = {mobileNo : $("#mobileNo").val(),nricPass:$("#nricPass").val()};
                 Common.ajax("GET","/enquiry/getCustomerLoginInfo.do", param , function (result){
                     console.log(result);
                     if(result.code =="00"){
                    	 document.getElementById("Msg").innerHTML =  result.message;
                    	 $("#successModalClick").click();
                     }
                     else{
                    	 document.getElementById("MsgAlert").innerHTML =  result.message;
                         $("#alertModalClick").click();
                     }
                 });
        });
        toggleSwitch();
    });

    function toggleSwitch(){
        $("#customSwitches").change(function() {
            if ($(this).is(':checked')) {
                  document.getElementById("nricPass").setAttribute("type", "text");
            }
            else{
                 document.getElementById("nricPass").setAttribute("type", "password");
            }
        });
    }

    function goNextPage(){
        $("#loginForm").attr("target", "");
        $("#loginForm").attr({
            action: getContextPath() + "/enquiry/selectCustomerInfo.do",
            method: "POST"
        }).submit();
    }

    function reload(){
        location.reload();
    }
</script>

<body>
<div class="login-box" id="customerLogin">
    <div>
        <div class="row">

             <div class="col-sm-6 hide-on-mobile">
                    <div style="height:180px"></div>
                    <div id="demo" class="carousel slide" data-ride="carousel">
                        <!-- Indicators -->
                        <ul class="carousel-indicators">
                            <li data-target="#demo" data-slide-to="0" class="active"></li>
                            <li data-target="#demo" data-slide-to="1"></li>
                        </ul>
                        <!-- The slideshow -->
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <div class="slider-feature-card">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/qualityTrust.png" alt="Coway">
                                    <h3 class="slider-title">Verify Info</h3>
                                    <h6 class="slider-description">To proceed with update installation address, we need to clarify that you're our genuine customer.</h6>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <div class="slider-feature-card">
                                    <img src="${pageContext.request.contextPath}/resources/images/common/loginicon.png" alt="Coway">
                                    <h3 class="slider-title">Login Info</h3>
                                    <h6 class="slider-description">Kindly please provide NRIC/ Passport No and main mobile number that register with Coway.</h6>
                                </div>
                            </div>
                        </div>
                        <!-- Left and right controls -->
                        <a class="carousel-control-prev" href="#demo" data-slide="prev">
                            <span class="carousel-control-prev-icon"></span>
                        </a>
                        <a class="carousel-control-next" href="#demo" data-slide="next">
                            <span class="carousel-control-next-icon"></span>
                        </a>
                    </div>
             </div>

            <div class="col-sm-6">
                    <div style="height:180px"></div>
                    <div class="row">
			              <div class="col-sm-12">
			                  <div class="logo">
			                      Coway Change <br>Your Life
			                  </div>
			              </div>
                    </div>

                     <br>
                     <h3 class="header-title">LOGIN</h3>
	                 <form class="login-form" id="loginForm" role="form">
		                   <div class="form-group">
		                        <input type="password" class="form-control" placeholder="Enter your NRIC No./ Passport No." name="nricPass" id="nricPass"/>
		                   </div>
		                   <div class="form-group">
		                        <input type="text" class="form-control" placeholder="Enter your mobile number" name="mobileNo" id="mobileNo"/>
		                   </div>
		                   <div>
		                    <div class="custom-control custom-switch">
		                        <input type="checkbox" class="custom-control-input" id="customSwitches">
		                        <label class="custom-control-label" for="customSwitches" >Show NRIC / Passport No</label>
		                     </div>
		                   </div>
		                   <div class="form-group">
		                    <p class="btn btn-primary btn-block"  id="btnSubmit" ><a href="javascript:void(0);" style="color:white">Submit</a></p>
		                   </div>
	               </form>
              </div>
        </div>
    </div>
</div>
<input type="button" id="successModalClick" data-toggle="modal" data-target="#myModalSuccess" hidden/>
<div class="modal" id="myModalSuccess" style="height:500px">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="Msg"></div>
            <div class="modal-footer">
                   <div class="container">
	                    <div class="row">
	                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
	                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
	                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" onclick="goNextPage()" style="width:100%;">Close</button>
	                          </div>
	                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert" hidden />
<div class="modal" id="myModalAlert" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgAlert"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" onclick="reload()" style="width:100%;">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>


