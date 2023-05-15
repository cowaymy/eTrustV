<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon.css"/>

<div style="height: 100vh; flex-direction:column;" class="d-flex align-items-center mainBackground">
		<div style="flex:1; justify-content:end;" class="flexColumn">
		        <div><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
		        <div class="mt-5"></div>
		</div>
        <div class="container-fluid" style="flex:2">
		       <div class="card mainBorderColor m-auto" style="max-width:576px">
					    <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
					        <h5 class="header">Order Information</h5>
					    </div>
			            <div class="card-body m-4 mainBorderColor">
							    <div class="row">
							          <div class="col-6"><h4>Installation Note: </h4></div>
							          <div class="col-6"><h4 class="font-weight-bold">${installationInfo.installEntryNo}</h4></div>
							    </div>
								<div class="row">
								          <div class="col-6"><h5>Order No: </h5></div>
								          <div class="col-6"><h5>${installationInfo.salesOrdNo}</h5></div>
								 </div>
					            <div class="row">
					                 <div class="col-6"><h5>Order Date: </h5></div>
					                 <div class="col-6"><h5 id="salesDt"></h5></div>
					            </div>
					            <div class="row">
					                 <div class="col-6"><h5>Do Date: </h5></div>
					                 <div class="col-6"><h5 id="doDt"></h5></div>
					            </div>
			            </div>
				        <div class="row justify-content-center mt-3">
				              <div class="col-5">
				                    <div class="form-group">
				                         <p class="btn btn-primary btn-block btn-lg"  id="btnComplete" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Completed</a></p>
				                    </div>
				              </div>
				              <div class="col-5">
				                    <div class="form-group">
				                         <p class="btn btn-danger btn-block btn-lg"  id="btnFail" ><a href="javascript:void(0);" style="color:white">Failed</a></p>
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
            <div class="modal-body" id="MsgAlert" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right btn-lg" data-dismiss="modal" style="width:100%;background:#4f90d6 !important"><a>Close</a></button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
	$(function(){
		   let x = document.querySelector('.bottom_msg_box');
		    x.style.display = "none"
	});

	console.log("${installationInfo.dupCheck}");

    $("#salesDt").text($("#salesDt").text() + moment("${installationInfo.salesDt}").format("DD-MM-YYYY"))
    $("#doDt").text($("#doDt").text() + moment("${installationInfo.installDt}").format("DD-MM-YYYY"))

    $("#btnFail").click(e => {
    	e.preventDefault();
    	 if("${installationInfo.dupCheck}" == "0") {
    		 window.location = "/homecare/services/install/getAcInsFail.do?insNo=${insNo}";
        }else{
            document.getElementById("MsgAlert").innerHTML =  "This order is not allowed to submit again.";
            $("#alertModalClick").click();
        }
    })

     $("#btnComplete").click(e => {
        e.preventDefault();
        if("${installationInfo.dupCheck}" == "0") {
        	 window.location = "/homecare/services/install/getAcInsComplete.do?insNo=${insNo}";
        }else{
        	 document.getElementById("MsgAlert").innerHTML =  "This order is not allowed to submit again.";
             $("#alertModalClick").click();
        }
    })
</script>

