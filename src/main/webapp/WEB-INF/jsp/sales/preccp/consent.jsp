<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon.css"/>
<style>
    #customerLogin, #invalidUrl, #completeConsent{
        display: flex;
        align-items: center;
        justify-content: center;
        min-height:100vh;
        padding-right: 0 !important;
    }

    .textContent{
        text-align:justify;
        line-height:2;
    }
</style>
<body>
<div class="login-box" id="customerLogin" style="display:none;">
  <div class="container">
    <div class="row">
        <div class="col-sm-12">
	        <div class="card">
		          <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
		              <div>
		                  <img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway">
		              </div>
		          </div>
		          <div class="card-body">
		                <h4 class="card-title text-center" style="text-decoration: underline;">Consent Content (via link)</h4>
		                <div>
			                  <h5 class="textContent"><input type="checkbox" id="chkConsent" style="transform: translate(0, 20%);"/><span>&nbsp;&nbsp;I hereby authorise any credit reporting agencies (‘CRAs’) licensed under the Credit Reporting Agencies Act 2010 including CRAs appointed by Coway, CCRIS and BNM to disclose my credit information to Coway; and give consent to Coway to collect, process, verify and/or use the said credit information including my personal data to evaluate my credit standing for rental of a Coway appliance.</span></h5>
		                </div>
		                <div class="row">
	                          <div class="col-lg-12 col-md-12 col-xs-6 col-sm-6">
	                          <button type="button" class="btn btn-primary btn-block" onclick="submitForm()">Submit</button>
	                          </div>
		                </div>
		           </div>
	        </div>
        </div>
      </div>
   </div>
</div>

<div class="login-box" id="invalidUrl" style="display:none;">
  <div class="container">
    <div class="row">
      <div class="col-sm-12">
            <div class="card">
                  <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                      <div>
                          <img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway">
                      </div>
                  </div>
                  <div class="card-body">
                        <h4 class="card-title text-center" style="text-decoration: underline;">Consent Content (via link)</h4>
                        <div>
                              <h5 class="textContent">The link is not valid. Kindly please access correct URL from your received SMS.</span></h5>
                        </div>
                   </div>
            </div>
        </div>
      </div>
   </div>
</div>
<div id="loading" style="position: fixed; top: 0; bottom: 0; left: 0; right: 0; background-color: rgba(0,0,0,0.1); display: none; justify-content: center; align-items: center;">
	<div class="spinner-border" style="width: 3rem; height: 3rem;" role="status">
	  <span class="sr-only">Loading...</span>
	</div>
</div>
<div class="login-box" id="completeConsent" style="display:none;">
  <div class="container">
    <div class="row">
      <div class="col-sm-12">
            <div class="card">
                  <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                      <div>
                          <img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway">
                      </div>
                  </div>
                  <div class="card-body">
                        <h4 class="card-title text-center" style="text-decoration: underline;">Consent Content (via link)</h4>
                        <div>
                              <h5 class="textContent">You have submitted completely your consent form.</span></h5>
                        </div>
                   </div>
            </div>
        </div>
      </div>
   </div>
</div>
</body>

<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert"  hidden/>
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

<input type="button" id="alertModalClick2" data-toggle="modal" data-target="#myModalAlert2"  hidden/>
<div class="modal" id="myModalAlert2" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgAlert2"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" style="width:100%;">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>

    const reload = () => {
    	location.reload();
    }

    const redirect = () => {
    	if("${d}"){
    	    $("#customerLogin").show();
    	    $("#invalidUrl").hide();
            $("#completeConsent").hide();
    	}else{
            $("#customerLogin").hide();
            $("#invalidUrl").show();
            $("#completeConsent").hide();
    	}
    }

    const checkStatus = () => {
    	if("${d}"){
            fetch("/sales/ccp/checkStatus.do?id=${d}")
            .then(r=>r.json())
            .then(data =>{
                if(!data.chkStatus){
                    redirect();
                }
                else{
                    $("#customerLogin").hide();
                    $("#invalidUrl").hide();
                    $("#completeConsent").show();
                }
            });
    	}
    }

    redirect();
    checkStatus();

    const submitForm = () => {
    	let chkConsent = document.querySelector("#chkConsent").checked;
    	if(chkConsent){
    		document.querySelector("#loading").style.display ="flex";
    		fetch("/sales/ccp/submitConsent.do",{
                method : "POST",
                headers : {
                    "Content-Type" : "application/json",
                },
                body : JSON.stringify({id: "${d}"})
    		})
    		.then(r=>r.json())
    		.then(data => {
    			document.querySelector("#loading").style.display ="none";
   				document.getElementById("MsgAlert").innerHTML =  "<span style='line-height:2'>" + data.message + "</span>";
   				$("#alertModalClick").click();
    		})
    	}else{
    		document.getElementById("MsgAlert2").innerHTML = "<span style='line-height:2'>Pleace tick the checkbox before proceed to submit the consent form.</span>";
            $("#alertModalClick2").click();
    	}
    }

    $(function() {
        document.querySelector(".bottom_msg_box").style.display ="none";
    });
</script>







