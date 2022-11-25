<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
#popup_wrap_selectOrgToRejoin .popup_wrap{
     margin-top: 50px;
 }
#popup_wrap_selectOrgToRejoin .pop_body{
     max-height:400px!important;
 }
#popup_wrap_selectOrgToRejoin .pop_body ul#orgRejoinItemList{
    text-align:center;
}
#popup_wrap_selectOrgToRejoin .pop_body ul#orgRejoinItemList li{
    box-sizing:border-box;
    border-bottom: 1px solid #ddd;
    border-left: 1px solid #ddd;
    border-right: 1px solid #ddd;
    padding: 20px 0;
}
#popup_wrap_selectOrgToRejoin .pop_body ul#orgRejoinItemList li:first-child{
    border-top: 1px solid #ddd;
    background:#007fff;
    color:#fff;
    font-weight:bold;
    font-size:20px;
}
#popup_wrap_selectOrgToRejoin .pop_body ul#orgRejoinItemList li:not(:first-child):hover{
    background-color: #D9E5FF;
    cursor:pointer;
    color:#000;
}
#popup_wrap_selectOrgToRejoin .pop_body ul#orgRejoinItemList li:not(:first-child).active{
    background-color: #D9E5FF;
    cursor:pointer;
    color:#000;
}
#popup_wrap_selectOrgToRejoin .pop_body ul#orgRejoinItemList li:last-child{
    margin-bottom: 18px;
}
#popup_wrap_selectOrgToRejoin .pop_body ul.center_btns{
    margin-top: 18px;
}

</style>

<script type="text/javaScript">
    var atchFileGrpId;
    var attachList;
    var myFileCaches = {};

	$(document).ready(function(){
        $('#cancelBtn').click(function() {
            $('#closeBtn').trigger("click");
        });

        $('#saveBtn').click(function() {
            fn_submitMemberRejoinForm();
        });

        $(".orgItem").click(function(){
            $(".orgItem.active").removeClass("active");
            $(this).addClass('active');
        });

        $('#fileName').change(function(evt) {
            var file = evt.target.files[0];
            if(file == null && myFileCaches[1] != null){
                delete myFileCaches[1];
            }else if(file != null){
                myFileCaches[1] = {file:file};
            }
        });
	});

	function fn_validation(){
		if(!($(".orgItem").hasClass("active"))){
			Common.alert("Please select organization to rejoin.");
			return false;
		}

		if($("#fileName").val() == null || $("#fileName").val() == ''){
            Common.alert('Member rejoin application form is required.');
            return false;
        }

		return true;
	}

	function fn_submitMemberRejoinForm(){
		if(!fn_validation()){
			return false;
		}else {

			var fileName = $("#fileName").val().split('\\');
		    var atchFileGrpId = '';
		    var atchFileId = '';
		    var isAttach = 'No';

		    var formData = new FormData();
		    $.each(myFileCaches, function(n, v) {
		        console.log("n : " + n + " v.file : " + v.file);
		        formData.append(n, v.file);
		    });

		    Common.ajaxFile("/organization/attachTerminationFileUpload.do", formData, function(result) {
	            console.log(result);
	            atchFileGrpId = result.data.fileGroupKey;
	            atchFileId = result.data.atchFileId;
	            isAttach = 'Yes';

	            var selectedData = {
		             selectMemId : $("#memberID").val(),
		             selectMemName : $("#memberName").val(),
		             selectMemCode : $("#memberCode").val(),
		             selectNric : $("#nric").val(),
		             selectOrgItem :  $(".orgItem.active").attr("id"),
		            selectAtchFileId : atchFileId
		         }

		         Common.ajax("POST", "/organization/submitMemberRejoinForm.do", selectedData, function(result) {
		        	 if(result.code == "00"){
		        		 Common.alert("Success to submit. Pending to Approval.", fn_memberEligibilitySearch);
		        	 }else {
		        		 Common.alert(result.message, fn_memberEligibilitySearch);
		        	 }
	                    $("#popup_wrap_selectOrgToRejoin").remove();
                });
            });
		}
	}
</script>


<!-- Pop up when member is eligible to rejoin -->
<div id="popup_wrap_selectOrgToRejoin" class="popup_wrap size_small"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
    <h1>Select Organization to Rejoin</h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" id="closeBtn">CLOSE</a></p></li>
    </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form id="orgRejoinform">
	        <input type="hidden" id="memberID" name="memberID" value="${memId}"/>
	        <input type="hidden" id="memberName" name="memberName" value="${memName}"/>
	        <input type="hidden" id="memberCode" name="memberCode" value="${memCode}"/>
	        <input type="hidden" id="nric" name="nric" value="${nric}"/>
            <input type="hidden" id="atchFileId" name="atchFileId">

            <ul id="orgRejoinItemList">
                <li>Select Organization to Rejoin</li>
                <li class="orgItem" id="1">1. Rejoin to HP Organization</li>
                <li class="orgItem" id="2">2. Rejoin to CD Organization</li>
                <li class="orgItem" id="7">3. Rejoin to HT Organization</li>
                <li class="orgItem" id="3">4. Rejoin to CT Organization</li>
            </ul>

			<table class="type1" id="terminateAttachment">
			    <caption><spring:message code="webInvoice.table" /></caption>
			    <colgroup>
			        <col style="width:75px" />
			        <col style="width:130px" />
			    </colgroup>
			    <tbody>
			        <tr>
			            <th>Member Rejoin Application Form</th>
			            <td id="attachTd">
			                <div class="auto_file2 w100p">
					            <input type="file" title="file add" id="fileName" />
					            <label>
					                <input type='text' class='input_text' id='labelFileInput'/>
					                <span class='label_text' id="labelFile"><a href='#'>Upload</a></span>
					            </label>
					        </div>
			            </td>
			        </tr>
			    </tbody>
			</table><!-- table end -->

            <ul class="center_btns">
			    <li><p class="btn_blue2 big"><a href="#" id="saveBtn">SAVE</a></p></li>
			    <li><p class="btn_blue2 big"><a href="#" id="cancelBtn">CANCEL</a></p></li>
			</ul>
       </form>
    </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
