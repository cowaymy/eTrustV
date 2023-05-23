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
        <div class="container-fluid" style="flex:2" >
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Order Information</h5>
                        </div>
                        <div>
                        <div class="card-body m-4 mainBorderColor"  id="page1">
                                <div class="row">
                                      <div class="col-12 font-italic"><h5 class="text-danger">This order has been submitted.</h5></div>
                                </div>
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
                                     <div class="col-6"><h5>Appointment Date: </h5></div>
                                     <div class="col-6"><h5 id="doDt"></h5></div>
                                </div>
                                <div class="row complete">
                                     <div class="col-6"><h5>Indoor Serial Number: </h5></div>
                                     <div class="col-6"><h5>${installationInfo.serialNo}</h5></div>
                                </div>
                                <div class="row complete">
                                     <div class="col-6"><h5>Outdoor Serial Number: </h5></div>
                                     <div class="col-6"><h5>${installationInfo.serialNo2}</h5></div>
                                </div>
                                <div class="row fail">
	                                <div class="col-6"><h5>Fail Location: </h5></div>
	                                <div class="col-6"><h5 id="location"></h5></div>
                                </div>
                                <div class="row fail">
                                    <div class="col-6"><h5>Fail Reason: </h5></div>
                                    <div class="col-6"><h5 id="reason"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Remark: </h5></div>
                                     <div class="col-6"><h5>${installationInfo.remark}</h5></div>
                                </div>
                        </div>

                       <div class="card-body m-4 mainBorderColor" id="page2">
                               <div class="row">
                                     <div class="col-12"><h5>This installation (${installationInfo.installEntryNo}) has been completed.</h5></div>
                               </div>
                       </div>


                       <div class="card-body m-4 mainBorderColor" id="page3">
                               <div class="row">
                                     <div class="col-12"><h5>This installation (${installationInfo.installEntryNo}) has been failed.</h5></div>
                               </div>
                       </div>

                 </div>
        </div>
     </div>
</div>

<div style="display:none;">
      <select class="form-control" id="failLoc">
              <option value="8000">FAILED AT LOCATION</option>
              <option value="8100">FAIL BEFORE ARRIVE LOCATION</option>
      </select>
      <select class="w100p" id=failReasonCode name="failReasonCode">
      </select>
</div>


<script>
    $(function(){
         let x = document.querySelector('.bottom_msg_box');
         x.style.display = "none"

        $("#salesDt").text($("#salesDt").text() + moment("${installationInfo.salesDt}").format("DD-MM-YYYY"))
        $("#doDt").text($("#doDt").text() + moment("${installationInfo.installDt}").format("DD-MM-YYYY"))
        $("#failLoc").val("${installationInfo.falLoc}");
         if(!$("#failLoc option:selected").val()){
             $("#location").text("-");
             $("#reason").text("-");
         }else{
	        $("#location").text($("#failLoc option:selected").text());
	        doGetCombo('/services/selectFailChild.do', "${installationInfo.falLoc}", '','failReasonCode', 'S' , `(() => {
	            $("#failReasonCode").val("${installationInfo.falRsn}");
	            $("#reason").text($("#failReasonCode option:selected").text());
	        })`);
         }

        const page1 = document.querySelector("#page1");
        const page2 = document.querySelector("#page2");
        const page3 = document.querySelector("#page3");

        const openPage1 = () =>{
            page1.style.display ="";
            page2.style.display ="none";
            page3.style.display ="none";
        }

        const openPage2 = () =>{
            page1.style.display ="none";
            page2.style.display ="";
            page3.style.display ="none";
        }

        const openPage3 = () =>{
            page1.style.display ="none";
            page2.style.display ="none";
            page3.style.display ="";
        }

       console.log("${installationInfo.mainStus}");

        if("${installationInfo.mainStus}" == "4"){
        	openPage2();
        }
        else if("${installationInfo.mainStus}" == "21"){
        	openPage3();
        }else{
	            if("${installationInfo.stusCodeId}" == "4"){
	            	openPage1();
	                showComplete();
	            }else{
	                openPage1();
	                showFail();
	            }
        }


    });

    const complete = document.querySelectorAll('.complete');
    const fail = document.querySelectorAll('.fail');

    const showComplete = e => {
    	for (let i = 0; i < complete.length; i++) {
    		complete[i].style.display = "";
        }

    	for (let i = 0; i < fail.length; i++) {
    		fail[i].style.display = "none";
        }
    }

    const showFail = e => {
        for (let i = 0; i < complete.length; i++) {
            complete[i].style.display = "none";
        }

        for (let i = 0; i < fail.length; i++) {
            fail[i].style.display = "";
        }
    }


</script>

