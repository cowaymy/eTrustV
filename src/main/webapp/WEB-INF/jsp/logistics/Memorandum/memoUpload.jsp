<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}


#editWindow {
    font-size:13px;
}
#editWindow label, input {}
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<!-- EDITOR -->
<script type="text/javaScript" language="javascript">
    _editor_area = "editorArea";        //  -> 페이지에 웹에디터가 들어갈 위치에 넣은 textarea ID
    _editor_url = "<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/'/>";
</script>
<script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/htmlarea.js'/>">
</script>
<!-- EDITOR -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

var myFileCaches = {};
var atchFileGrpId = '';
var atchFileId = '';
var checkFileValid = true;
var newFileName = '';
var orgFileName = '';

    $(document).ready(function(){
    	HTMLArea.init();
        HTMLArea.onload = initEditor;

        doGetCombo('/logistics/memorandum/selectMemoType.do', '' , '', 'listMemoType' , 'S', '');

    });

    $(function(){
    	$("#upload").click(function(){
    		fn_saveConfirm();
        });
    	$("#clear").click(function(){
    		$("#searchForm")[0].reset();
    	});
    });

    $(function(){
    	$('#memoFile').change(function(evt) {

            var file = evt.target.files[0];
            if(file == null && myFileCaches[1] != null){
                delete myFileCaches[1];
            }else if(file != null){
                myFileCaches[1] = {file:file};
            }

           var msg = '';

           var fileType = file.type.split('/');
           if(fileType[1] != 'pdf'){
               msg += "*Only allow attachment format (PDF).<br>";
           }
           newFileName = "";
           if ($("#listMemoType").val() != '') {
	           if ($("#listMemoType").val() == '7173') {
	        	   if(file.name != "Universal_memo.pdf" ){
	        		   msg += "*Invalid Memo File Name.<br>Memo Type must match with file name Universal_memo.pdf";
	        	   }
	        	   $("#searchForm #orgFileName").val('Universal_memo.pdf');
	        	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/Universal_memo.pdf");
	           }else if($("#listMemoType").val() == '7172'){
	        	   if(file.name != "MessageFromManagingDirector.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name MessageFromManagingDirector.pdf";
                   }
	        	   $("#searchForm #orgFileName").val('MessageFromManagingDirector.pdf');
	               $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/MessageFromManagingDirector.pdf");
               }else if($("#listMemoType").val() == '7171'){
            	   if(file.name != "HP_MEMO_INCENTIVE.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name HP_MEMO_INCENTIVE.pdf";
                   }
            	   $("#searchForm #orgFileName").val('HP_MEMO_INCENTIVE.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/HP_MEMO_INCENTIVE.pdf");
               }else if($("#listMemoType").val() == '7170'){
            	   if(file.name != "CowaySalesManagerAgreement_SM.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowaySalesManagerAgreement_SM.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowaySalesManagerAgreement_SM.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowaySalesManagerAgreement_SM.pdf");
               }else if($("#listMemoType").val() == '7169'){
            	   if(file.name != "CowaySalesManagerAgreement_HM.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowaySalesManagerAgreement_HM.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowaySalesManagerAgreement_HM.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowaySalesManagerAgreement_HM.pdf");
               }else if($("#listMemoType").val() == '7168'){
            	   if(file.name != "CowaySalesManagerAgreement_GM.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file nameCowaySalesManagerAgreement_GM.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowaySalesManagerAgreement_GM.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowaySalesManagerAgreement_GM.pdf");
               }else if($("#listMemoType").val() == '7167'){
            	   if(file.name != "CowaySalesManagerAgreement.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowaySalesManagerAgreement.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowaySalesManagerAgreement.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowaySalesManagerAgreement.pdf");
               }else if($("#listMemoType").val() == '7166'){
            	   if(file.name != "CowayHomecareTechnicianManagerAgreement.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowayHomecareTechnicianManagerAgreement.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowayHomecareTechnicianManagerAgreement.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowayHomecareTechnicianManagerAgreement.pdf");
               }else if($("#listMemoType").val() == '7165'){
            	   if(file.name != "CowayHomecareTechnicianAgreement.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowayHomecareTechnicianAgreement.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowayHomecareTechnicianAgreement.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowayHomecareTechnicianAgreement.pdf");
               }else if($("#listMemoType").val() == '7164'){
            	   if(file.name != "CowayHealthPlannerAgreement.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowayHealthPlannerAgreement.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowayHealthPlannerAgreement.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowayHealthPlannerAgreement.pdf");
               }else if($("#listMemoType").val() == '7163'){
            	   if(file.name != "CowayCodyAgreement.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name CowayCodyAgreement.pdf";
                   }
            	   $("#searchForm #orgFileName").val('CowayCodyAgreement.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/CowayCodyAgreement.pdf");
               }else if($("#listMemoType").val() == '7162'){
            	   if(file.name != "ConsentLetter.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name ConsentLetter.pdf";
                   }
            	   $("#searchForm #orgFileName").val('ConsentLetter.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/ConsentLetter.pdf");
               }else if($("#listMemoType").val() == '7161'){
            	   if(file.name != "Agreement_C.pdf" ){
                       msg += "*Invalid Memo File Name.<br>Memo Type must match with file name Agreement_C.pdf";
                   }
            	   $("#searchForm #orgFileName").val('Agreement_C.pdf');
            	   $("#searchForm #newFileName").val("/resources/report/prd/organization/LoginPopUp/Agreement_C.pdf");
               }else {
	                msg += "*Invalid Memo File Name and Memo Type.<br>Please raise ticket to Trustdesk.";
	            }
           }
           else
       	    {
        	   msg += "*Please select Memo Type";
       	    }

            if(file.size > 3000000){
                msg += "*Only allow attachment with less than 3MB.<br>";
            }

            if(msg != null && msg != ''){
                myFileCaches[1].file['checkFileValid'] = false;
                delete myFileCaches[1];
                $('#memoFile').val("");
                Common.alert(msg);
            }
            else{
                myFileCaches[1].file['checkFileValid'] = true;
            }
        });
    });

    function fn_saveConfirm(){
    	 if(fn_validFile()) {
    		   Common.confirm("<spring:message code='sys.common.alert.save'/>", UploadMemoAjax);
    	 }
    }

    function fn_validFile() {
        var isValid = true, msg = "";

         if(FormUtil.isEmpty($('#memoFile').val())) {
            isValid = false;
            msg += "Please upload PDF File<br>";
        }else{

	        if(FormUtil.isEmpty($('#crtsdt').val()) || FormUtil.isEmpty($('#crtedt').val())) {
	        	isValid = false;
	            msg +=  "* Please key in valid start and end date.";
	        }else{

	        	var currDt = new Date();

	        	var validStartDt = $("#crtsdt").val();
	        	var validEndDt = $("#crtedt").val();

	        	validStartDt = validStartDt.replace(/[&\/\\#,+()$~%.'":*?<>{}]/g, '');
	        	validEndDt = validEndDt.replace(/[&\/\\#,+()$~%.'":*?<>{}]/g, '');

	        	var strDay = validStartDt.substring(0, 2);
	        	var strMonth = validStartDt.substring(2, 4);
	            var strYear = validStartDt.substring(4, 8);

	            var endDay = validEndDt.substring(0, 2);
	            var endMonth = validEndDt.substring(2, 4);
	            var endYear = validEndDt.substring(4, 8);

	            if(currDt.getMonth() == 12){
	            	currDt.setMonth(currDt.getMonth() + 1);
	            	currDt.setFullYear(currDt.getFullYear() - 1);
	            }else{
	            	currDt.setMonth(currDt.getMonth() + 1);
	            }

	            var  currYear = currDt.getFullYear();
	            var currMonth = currDt.getMonth();
	            var  currDay = currDt.getDate();
	            if(strYear >= currYear ){
	                if(strYear == currYear && strMonth < currMonth ){
	                    isValid = false;
	                    msg +=  "* Valid start date must be today or future date.";
	                }else{
	                	if(strDay < currDay ||  endDay < currDay){
	                		isValid = false;
	                        msg +=  "* Valid start and end date must be today or future date.";
	                	}else if(endYear >= strYear ){
	                		if(endYear == strYear){
	                			if( endMonth < strMonth ){
		                            isValid = false;
		                            msg +=  "* Valid end date must greater than start date.";
		                        }else if( endMonth == strMonth && endDay < strDay){
		                            isValid = false;
		                            msg +=  "* Valid end date must greater than start date.";
		                        }
	                		}
	                    }else{
	                        isValid = false;
	                        msg +=  "* Valid end date must greater than start date.";
	                    }
	                }
	            }else{
	                isValid = false;
	                msg +=  "* Valid start date must be today or future date.";
	            }
	        }
        }
        if(!isValid) Common.alert("Upload File Validation" + DEFAULT_DELIMITER + "<b>"+msg+"</b>");

        return isValid;
    }

    function UploadMemoAjax() {

    	var formData = new FormData();
        $.each(myFileCaches, function(n, v) {
            console.log("n : " + n + " v.file : " + v.file);
            formData.append(n, v.file);
        });

         	Common.ajaxFile("/logistics/memorandum/attachFileMemberUpload.do", formData, function(result) {
    		if(result != 0){
    		    console.log(result);
    		    Common.ajax("POST", "/logistics/memorandum/memoHistSave", $("#searchForm").serializeJSON() , function(result) {
	                if(result != 0){
	                	   console.log(result);
	                }else{
	                    Common.alert("Fail to insert History Log" + DEFAULT_DELIMITER + result.message);
	                }
	            });

	    	}else{
	            Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
	    	}
        });
    }

</script>

<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Memorandum</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Memo Upload</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="upload"><span class="upload"></span>Upload</a></p></li>
     <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<input type="hidden" name="orgFileName" id="orgFileName" />
<input type="hidden" name="newFileName" id="newFileName" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Memo Type<span style="color:red">**</span></th>
    <td><select id="listMemoType" name="listMemoType" class="w100p"></select></td>
    <th scope="row">Valid Date</th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>
        <span>To</span>
        <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date "></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row"></th>
    <td colspan="1" ></td>
</tr>
<tr>

    <th scope="row">Memo File</th>
    <td colspan="3" id="attachTd">
        <div class="auto_file" >
            <input id="memoFile" name="memoFile" type="file" title="file add"  accept="pdf"/>
        </div>
    </td>
    <th scope="row"></th>
    <td colspan="1" ></td>

</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

</section>