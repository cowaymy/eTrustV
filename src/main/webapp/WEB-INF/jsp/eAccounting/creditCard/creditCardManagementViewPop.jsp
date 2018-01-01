<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
//file action list
var update = new Array();
var remove = new Array();
var attachmentList = new Array();
<c:forEach var="file" items="${attachmentList}">
var obj = {
        atchFileGrpId : "${file.atchFileGrpId}"
        ,atchFileId : "${file.atchFileId}"
        ,atchFileName : "${file.atchFileName}"
};
attachmentList.push(obj);
</c:forEach>
$(document).ready(function () {
	// 수정시 첨부파일이 없는경우 디폴트 파일태그 생성
    console.log(attachmentList);
    if(attachmentList.length <= 0) {
        setInputFile2();
    }
    
    $("#holder_search_btn").click(function() {
        clickType = "newHolder";
        fn_searchUserIdPop();
    });
    $("#charge_search_btn").click(function() {
        clickType = "newCharge";
        fn_searchUserIdPop();
    });
    $("#costCenter_search_btn").click(fn_popCostCenterSearchPop);
    $("#save_btn").click(fn_saveViewMgmt);
    
 // 파일 다운
    $(".auto_file2 :text").dblclick(function() {
        var oriFileName = $(this).val();
        var fileGrpId;
        var fileId;
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                fileGrpId = attachmentList[i].atchFileGrpId;
                fileId = attachmentList[i].atchFileId;
            }
        }
        fn_atchViewDown(fileGrpId, fileId);
    });
    // 파일 수정
    $("#form_newMgmt :file").change(function() {
        var div = $(this).parents(".auto_file2");
        var oriFileName = div.find(":text").val();
        console.log(oriFileName);
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                update.push(attachmentList[i].atchFileId);
                console.log(JSON.stringify(update));
            }
        }
    });
    // 파일 삭제
    $(".auto_file2 a:contains('Delete')").click(function() {
        var div = $(this).parents(".auto_file2");
        var oriFileName = div.find(":text").val();
        console.log(oriFileName);   
        for(var i = 0; i < attachmentList.length; i++) {
            if(attachmentList[i].atchFileName == oriFileName) {
                remove.push(attachmentList[i].atchFileId);
                console.log(JSON.stringify(remove));
            }
        }
    });
    
    $("#crditCardNoTd").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
    
    $("#appvCrditLimit").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;
        
   });
   
   $("#appvCrditLimit").click(function () { 
       var str = $("#appvCrditLimit").val().replace(/,/gi, "");
       $("#appvCrditLimit").val(str);      
  });
   $("#appvCrditLimit").blur(function () { 
       var str = $("#appvCrditLimit").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $("#appvCrditLimit").val(str);      
  });
   
    $("#appvCrditLimit").change(function(){
       var str =""+ Math.floor($("#appvCrditLimit").val() * 100)/100;
       
       var str2 = str.split(".");
      
       if(str2.length == 1){
           str2[1] = "00";
       }
       
       if(str2[0].length > 11){
           Common.alert('<spring:message code="pettyCashNewCustdn.Amt.msg" />');
           str = "";
       }else{
           str = str2[0].substr(0, 11)+"."+str2[1];
       }
       str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       
       
       $("#appvCrditLimit").val(str);
   });
    
    CommonCombo.make("bankCode", "/eAccounting/creditCard/selectBankCode.do", null, "${crditCardInfo.bankCode}", {
        id: "code",
        name: "name",
        type:"S"
    });
    
    fn_setCostCenterEvent();
    
    fn_setValues();
});

/* 인풋 파일(멀티) */
function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
}

function fn_setValues() {
	var crditCardNo = "${crditCardInfo.crditCardNo}"
	
	var crditCardNo1 = crditCardNo.substr(0, 4);
    var crditCardNo2 = crditCardNo.substr(4, 4);
    var crditCardNo3 = crditCardNo.substr(8, 4);
    var crditCardNo4 = crditCardNo.substr(12);
    
    $("#crditCardNo1").val(crditCardNo1);
    $("#crditCardNo2").val(crditCardNo2);
    $("#crditCardNo3").val(crditCardNo3);
    $("#crditCardNo4").val(crditCardNo4);
    
    var appvCrditLimit = "${crditCardInfo.appvCrditLimit}";
    $("#appvCrditLimit").val(appvCrditLimit.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
}

function fn_atchViewDown(fileGrpId, fileId) {
    var data = {
            atchFileGrpId : fileGrpId,
            atchFileId : fileId
    };
    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
        console.log(result);
        if(result.fileExtsn == "jpg" || result.fileExtsn == "png") {
            // TODO View
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
        } else {
            var fileSubPath = result.fileSubPath;
            fileSubPath = fileSubPath.replace('\', '/'');
            console.log("/file/fileDown.do?subPath=" + fileSubPath
                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            window.open("/file/fileDown.do?subPath=" + fileSubPath
                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
        }
    });
}

function fn_saveViewMgmt() {
    if(fn_checkEmpty()){
	console.log("Action");
        Common.popupDiv("/eAccounting/creditCard/viewRegistMsgPop.do", null, null, true, "registMsgPop");
    }
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="crditCardViewMgmt.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" enctype="multipart/form-data" id="form_newMgmt">
<input type="hidden" id="newCrditCardSeq" name="crditCardSeq" value="${crditCardInfo.crditCardSeq}">
<input type="hidden" id="newAtchFileGrpId" name="atchFileGrpId" value="${crditCardInfo.atchFileGrpId}">
<input type="hidden" id="newCrditCardUserId" name="crditCardUserId" value="${crditCardInfo.crditCardUserId}">
<input type="hidden" id="newChrgUserId" name="chrgUserId" value="${crditCardInfo.chrgUserId}">
<input type="hidden" id="newCostCenterText" name="costCentrName" value="${crditCardInfo.costCentrName}">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:190px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="crditCardMgmt.cardholderName" /></th>
	<td><input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="newCrditCardUserName" name="crditCardUserName" value="${crditCardInfo.crditCardUserName}" /><c:if test="${crditCardInfo.crditCardStus eq 'A'}"><a href="#" class="search_btn" id="holder_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row"><spring:message code="crditCardMgmt.crditCardNo" /></th>
	<td id="crditCardNoTd"><input type="text" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo1" name="crditCardNo1" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>/> <input type="password" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo2" name="crditCardNo2" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>/> <input type="password" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo3" name="crditCardNo3" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>/> <input type="text" title="" placeholder="" class="w23_5p" maxlength="4" id="crditCardNo4" name="crditCardNo4" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="crditCardMgmt.chargeName" /></th>
	<td><input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="newChrgUserName" name="chrgUserName" value="${crditCardInfo.chrgUserName}" /><c:if test="${crditCardInfo.crditCardStus eq 'A'}"><a href="#" class="search_btn" id="charge_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
	<th scope="row"><spring:message code="crditCardMgmt.chargeDepart" /></th>
	<td><input type="text" title="" placeholder="" class="" id="newCostCenter" name="costCentr" value="${crditCardInfo.costCentr}" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>/><c:if test="${crditCardInfo.crditCardStus eq 'A'}"><a href="#" class="search_btn" id="costCenter_search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></c:if></td>
</tr>
<tr>
	<th scope="row"><spring:message code="crditCardNewMgmt.issueBank" /></th>
	<td>
		<select class="multy_select" id="bankCode" name="bankCode" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">disabled</c:if>></select>
	</td>
	<th scope="row"><spring:message code="crditCardNewMgmt.cardType" /></th>
	<td>
		<select class="multy_select" id="crditCardType" name="crditCardType" value="${crditCardInfo.crditCardType}" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">disabled</c:if>>
		<option value="CC"><spring:message code="crditCardNewMgmt.crditCard" /></option>
		<option value="DC"><spring:message code="crditCardNewMgmt.debitCard" /></option>
		</select>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="crditCardNewMgmt.appvCrditLimit" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="appvCrditLimit" name="appvCrditLimit" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>/></td>
	<th scope="row"><spring:message code="crditCardNewMgmt.expiryDt" /></th>
	<td><input type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" id="crditCardExprDt" name="crditCardExprDt" value="${crditCardInfo.crditCardExprDt}" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">disabled</c:if>/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.attachment" /></th>
	<td colspan="3">
	<c:forEach var="files" items="${attachmentList}" varStatus="st">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <c:if test="${crditCardInfo.crditCardStus eq 'A'}">
    <input type="file" title="file add" style="width:300px" />
    <label>
    </c:if>
    <input type='text' class='input_text' readonly='readonly' value="${files.atchFileName}" />
    <c:if test="${crditCardInfo.crditCardStus eq 'A'}">
    <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
    </label>
    <span class='label_text'><a href='#' id="add_btn"><spring:message code="viewEditWebInvoice.add" /></a></span>
    <span class='label_text'><a href='#' id="remove_btn"><spring:message code="viewEditWebInvoice.delete" /></a></span>
    </c:if>
    </div><!-- auto_file end -->
    </c:forEach>
    <c:if test="${fn:length(attachmentList) <= 0}">
    <c:if test="${crditCardInfo.crditCardStus eq 'A'}">
    <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
    <input type="file" title="file add" style="width:300px" />
    </div><!-- auto_file end -->
    </c:if>
    </c:if>
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="newWebInvoice.remark" /></th>
	<td colspan="3"><textarea class="w100p" rows="2" style="height:auto" id="crditCardRem" name="crditCardRem" <c:if test="${crditCardInfo.crditCardStus ne 'A'}">readonly</c:if>>${crditCardInfo.crditCardRem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<c:if test="${crditCardInfo.crditCardStus eq 'A'}">
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="save_btn"><spring:message code="pettyCashNewCustdn.save" /></a></p></li>
</ul>
</c:if>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->