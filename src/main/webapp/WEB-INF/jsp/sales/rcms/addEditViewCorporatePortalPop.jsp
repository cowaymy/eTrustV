<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var msg = "";
var myFileCaches = {};
var atchFileGrpId = '';
var atchFileId = '';
var checkFileValid = true;

$(document).ready(function(){
    fn_viewType("${viewType}");

    CommonCombo.make('ddlCorpType', '/common/selectCodeList.do', {groupCode : 95,codeIn : 'GOV,NONGOV,PRIVATE'}, '', {type : 'S'});
    doGetCombo('/common/selectCodeList.do', '575', '', 'ddlInvMethod', 'S','fn_viewType');
    doGetCombo('/common/selectCodeList.do', '576', '', 'ddlPayTerm', 'S','fn_viewType');
    doGetCombo('/sales/rcms/selectPortalStusList.do', '', '', 'ddlPortalStus', 'S','fn_viewType');

});

function  fn_viewType(type){
    type = "${viewType}";

    $("#hdnPortalId").val('${portalInfo.portalId}');
    $("#txtPortalCode").val('${portalInfo.portalCode}');
    $("#txtPortalName").val('${portalInfo.portalName}');
    $("#ddlPortalStus").val('${portalInfo.portalStus}');
    $("#ddlCorpType").val('${portalInfo.corpType}');
    $("#ddlInvMethod").val('${portalInfo.invMethod}');
    $("#txtPortalLoginID").val('${portalInfo.loginId}');
    $("#txtPortalPass").val('${portalInfo.portalPass}');
    $("#txtPortalUrl").val('${portalInfo.portalUrl}');
    $("#ddlPayTerm").val('${portalInfo.paymentTerm}');
    $("#dtRegPeriod").val('${portalInfo.regPeriodMonth}' + '/' + '${portalInfo.regPeriodYear}');
    $("#txtRemark").val('${portalInfo.remark}');
    $("#txtRenewPeriod").val('${portalInfo.renewalPeriod}');
    $("#txtRenewFee").val('${portalInfo.renewalFee}');
    $("#ddlPortalPic1").val('${portalInfo.ccdPic1}');
    $("#ddlPortalPic2").val('${portalInfo.ccdPic2}');
    $("#ddlPortalPic3").val('${portalInfo.ccdPic3}');

    if (type == 2 || type == 1){ //Edit and New
        $('#btn_save').show();
    }

    if (type == 3){ //View

         $("#ddlCorpType").prop("disabled", true);
         $("#ddlPortalStus").prop("disabled", true);
         $("#ddlInvMethod").prop("disabled", true);
         $("#txtRenewPeriod").prop("disabled", true);
         $("#txtPortalName").prop("disabled", true);
         $("#txtRenewFee").prop("disabled", true);
         $("#txtPortalLoginID").prop("disabled", true);
         $("#ddlPortalPic1").prop("disabled", true);
         $("#ddlPortalPic2").prop("disabled", true);
         $("#ddlPortalPic3").prop("disabled", true);
         $("#txtPortalPass").prop("disabled", true);
         $("#txtPortalUrl").prop("disabled", true);
         $("#ddlPayTerm").prop("disabled", true);
         $("#dtRegPeriod").prop("disabled", true);
         $("#txtRemark").prop("disabled", true);

         $('#guidelineDiv').hide();
         $('#btn_save').hide();
    }
}

function fn_save(){

    var flag = false;
    var type = "${viewType}";

    if(fn_validate()){
        if(msg != "") {
            Common.alert(msg);
            flag = true;
        }
    }

    if(!flag){
        fn_savePortal();
    }
}

function fn_savePortal(){

        var portaltM = { //SAL0409M
        		viewType        : "${viewType}",
        		portalId        : "${portalInfo.portalId}",
        		portalCode      : $("#txtPortalCode").val(),
        		portalName      : $("#txtPortalName").val(),
        		portalStus      : $("#ddlPortalStus").val(),
        		corpType        : $("#ddlCorpType").val(),
        		invMethod       : $("#ddlInvMethod").val(),
        		loginId         : $("#txtPortalLoginID").val(),
        		portalPass      : $("#txtPortalPass").val(),
        		portalUrl       : $("#txtPortalUrl").val(),
        		paymentTerm     : $("#ddlPayTerm").val(),
        		regPeriod       : $("#dtRegPeriod").val(),
        		remark          : $("#txtRemark").val(),
        		renewPeriod     : $("#txtRenewPeriod").val(),
        		renewFee        : $("#txtRenewFee").val(),
        		ccdPic1         : $("#ddlPortalPic1").val(),
        		ccdPic2         : $("#ddlPortalPic2").val(),
        		ccdPic3         : $("#ddlPortalPic3").val(),

        		atchFileGrpId   : $("#atchFileGrpId").val(),
        		atchFileId      : $("#atchFileId").val()
        }

        var formData = Common.getFormData("portalForm");
        //var obj = $("#portalForm").serializeJSON();
        $.each(portaltM, function(key, value) {
            formData.append(key, value);
          });

        console.log("-------------------------" + JSON.stringify(formData));
        Common.ajaxFile("/sales/rcms/savePortal.do",  formData, function(result) {
            console.log("message : " + result.message );
            Common.alert(result.message,fn_saveclose);
            $("#popup_wrap").remove();
            fn_selectListAjax();
	});
}

function fn_saveclose() {
	portalPopupId.remove();
}

function fn_validate(){

    msg = "";
    //checkReges
    /* var checkRegexResult = true;
    var regExpSpecChar = /^[^*|\":<>[\]{}`\\';@&$]+$/; */

    if($("#ddlCorpType").val() == ""){
        msg += "* Please select corporate type <br>";
    }

    if($("#ddlPortalStus").val() == ""){
        msg += "* Please select portal status <br>";
    }

    if($("#ddlInvMethod").val() == ""){
        msg += "* Please select invoice method <br>";
    }

    if($("#txtRenewPeriod").val() == ""){
        msg += "* Please enter renew period <br>";
    }

    if($("#txtPortalName").val() == ""){
        msg += "* Please enter portal name <br>";
    }

    if($("#txtRenewFee").val() == ""){
        msg += "* Please enter renewal fee <br>";
    }

    if($("#txtPortalLoginID").val() == ""){
        msg += "* Please enter portal login ID <br>";
    }

    if($("#ddlPortalPic1").val() == ""){
        msg += "* Please select CCD 1st PIC <br>";
    }

    if($("#txtPortalPass").val() == ""){
        msg += "* Please enter portal password <br>";
    }

    if($("#txtPortalUrl").val() == ""){
        msg += "* Please enter portal URL <br>";
    }

    if($("#ddlPayTerm").val() == ""){
        msg += "* Please select payment term <br>";
    }

    if($("#dtRegPeriod").val() == ""){
        msg += "* Please select registration period <br>";
    }

    return msg;
}


</script>


<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>
<c:if test="${viewType eq  '1' }"> Add New Portal</c:if>
<c:if test="${viewType eq  '2' }"> Edit Portal Details</c:if>
<c:if test="${viewType eq  '3' }"> View Portal Details</c:if>
</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="height:450px"><!-- pop_body start -->

<form action="#" id="sForm"  name="saveForm" method="post"   onsubmit="return false;">

    <section class="search_table"><!-- search_table start -->
    <form action="#" method="post"  id='portalForm' name ='portalForm'>
             <div style="display: none">
                <input type="text" name="hdnPortalId" id="hdnPortalId"/>
             </div>
            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                 <col style="width: 130px" />
                 <col style="width: 350px" />
                 <col style="width: 170px" />
                 <col style="width: *" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">Portal Code</th>
                <td>
                    <input type="text" title="" class="w100p" id="txtPortalCode" name="txtPortalCode" disabled/>
                </td>
            </tr>
            <tr>
                <th scope="row">Corporate Type</th>
                <td>
                    <select class="w100p" id="ddlCorpType" name="ddlCorpType" ></select>
                </td>
                <th scope="row">Portal Status</th>
                <td>
                    <select class="w100p" id="ddlPortalStus" name="ddlPortalStus" ></select>
                </td>
            </tr>
            <tr>
                <th scope="row">Invoice Method</th>
                <td>
                    <select class="w100p" id="ddlInvMethod" name="ddlInvMethod" ></select>
                </td>
                <th scope="row">Renewal Period</th>
                <td>
                    <input type="text" title="" class="w100p"  id="txtRenewPeriod"  name="txtRenewPeriod" />
                </td>
            </tr>
            <tr>
                <th scope="row">Portal Name</th>
                <td>
                    <input type="text" title="" class="w100p"  id="txtPortalName"  name="txtPortalName" />
                </td>
                <th scope="row">Renewal Fees (RM)</th>
                <td>
                    <input type="text" title="" class="w100p"  id="txtRenewFee"  name="txtRenewFee" />
                </td>
            </tr>
            <tr>
                <th scope="row">Login ID</th>
                <td>
                    <input type="text" title="" class="w100p"  id="txtPortalLoginID"  name="txtPortalLoginID" />
                </td>
                <th scope="row">CCD Main PIC (Portal)</th>
                <td>
                    <select class="w100p" id="ddlPortalPic1" name="ddlPortalPic1" >
                        <option value="">Select One</option>
	                    <c:forEach var="list" items="${picList}" varStatus="status">
				        <option value="${list.agentId}">${list.agentName}</option>
				        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row">Password</th>
                <td>
                    <input type="text" title="" class="w100p"  id="txtPortalPass"  name="txtPortalPass" />
                </td>
                <th scope="row">CCD 2nd PIC (Portal)</th>
                <td>
                    <select class="w100p" id="ddlPortalPic2" name="ddlPortalPic2" >
                        <option value="">Select One</option>
                        <c:forEach var="list" items="${picList}" varStatus="status">
                        <option value="${list.agentId}">${list.agentName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row">URL</th>
                <td>
                    <input type="text" title="" class="w100p"  id="txtPortalUrl"  name="txtPortalUrl" />
                </td>
                <th scope="row">CCD 3rd PIC (Centralized)</th>
                <td>
                    <select class="w100p" id="ddlPortalPic3" name="ddlPortalPic3" >
                        <option value="">Select One</option>
                        <c:forEach var="list" items="${picList}" varStatus="status">
                        <option value="${list.agentId}">${list.agentName}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row">Payment Terms</th>
                <td>
                    <select class="w100p" id="ddlPayTerm" name="ddlPayTerm" ></select>
                </td>
                <th scope="row">Registration Period</th>
                <td>
                   <input id="dtRegPeriod" name="dtRegPeriod" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code='service.title.Remark' /></th>
                <td colspan="3">
                    <textarea cols="20" rows="5" placeholder="<spring:message code='service.title.Remark' />"
                       id='txtRemark' name='txtRemark'  ></textarea>
                 </td>
            </tr>
            <tr id ="guidelineDiv">
                <th scope="row">Attach guideline</th>
                            <td>
                                <div class="auto_file2 auto_file3">
                                    <input type="file" title="file add" id="guideline" accept="image/*,.pdf,.zip"/>
                                        <label>
                                            <input type='text' class='input_text' readonly='readonly' id='guidelineTxt'/>
                                            <span class='label_text'><a href='#'>Upload</a></span>
                                        </label>
                                </div>
                            </td>
                <th scope="row"></th>
                <td></td>
            </tr>
            <tr>
                <th scope="row">View Orders & Contact PIC</th>
                <td>
                    <span class='label_text'><a href='#' onclick='fileDown("1")'>Download</a></span>
                </td>
                <th scope="row"></th>
                <td></td>
            </tr>
            </tbody>
            </table><!-- table end -->
    </form>
    </section><!-- search_table end -->


    <ul class="center_btns">
        <li><p class="btn_blue2"><a href="#" id="btn_save" onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>
    </ul>
</form>

</section><!-- content end -->

</div>
