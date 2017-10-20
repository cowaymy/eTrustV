<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	
	//sampleformet pop button
	function fn_sampleFormat(val){
		if(val == null || val ==""){
			Common.alert('No Sample to show for this upload type.');
		}else{
			if (val == "1062"){
				Common.popupDiv("/commission/calculation/incntivUploadSamplePop.do");
	        }else{
	        	Common.alert('No Sample to show for this upload type.');
	        }
		};
	}

	//csv file upload save 
	function fn_uploadCsvFile(){
		if(fn_uploadValid()){
			Common.ajax("GET", "/commission/calculation/csvFileOverlapCnt", $("#newForm").serialize(), function(result) {
				if(result>0){
					Common.alert('One active upload batch exist. New upload is disallowed.');
				}else{
					var formData = new FormData();
					formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
			        formData.append("type", $("#cmbType").val());
			        formData.append("memberType", $("#cmbMemberType").val());
			        
			        Common.ajaxFile("/commission/csv/upload", formData, function (result) {
			        	$("#search").click();
			        	document.newForm.reset();
			            Common.alert("success");
			        });
				}
			});
		}
	}
	
	function fn_uploadValid(){
		if( $("#cmbType").val() == null || $("#cmbType").val() == ""){
			Common.alert("Please select the upload type first.");
			return false;
		}
		if( $("#cmbMemberType").val() == null || $("#cmbMemberType").val() == ""){
            Common.alert(" No Sample to show for this upload type");
            return false;
        }
		if( $("#uploadfile").val() == null || $("#uploadfile").val() == ""){
            Common.alert("Please select your csv file.");
            return false;
        }
		return true;
	}
</script>
<div id="popup_wrap" class="popup_wrap">
	
	<header class="pop_header">
		<h1>INCENTIVE/TARGET UPLOAD - NEW UPLOAD</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
		</ul>
	</header>
	
	<section class="pop_body">
	
		<form id="newForm" name="newForm">
		<table class="type1 mt10">
			<caption>table</caption>
			<colgroup>
				<col style="width:150px" />
				<col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">Type</th>
					<td>
						<select class="w100p" name="cmbType" id="cmbType">
						   <option value=""></option>
							<option value="1062">Cody/HP Incentive</option>
							<option value="1063">Cody/HP Target</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">Member Type</th>
					<td>
						<select class="w100p" name="cmbMemberType" id="cmbMemberType">
						   <option value=""></option>
							<c:forEach var="list" items="${memType }">
	                            <option value="${list.cdid}">${list.cdnm}(${list.cd})</option>
	                        </c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">File</th>
					<td>
	   					<!-- <div class="auto_file"> --><!-- auto_file start -->
	       					<input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
	   					<!-- </div> -->
					</td>
				</tr>
			</tbody>
		</table>
		</form>
		<ul class="center_btns">
			<li><p class="btn_blue"><a href="javascript:fn_uploadCsvFile();">Upload File</a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_sampleFormat($('#cmbType').val());">Sample Format</a></p></li>
			<li><p class="btn_blue"><a href="${pageContext.request.contextPath}/resources/download/IncentiveTargetUploadFormat.csv">Download CSV Format</a></p></li>
		</ul>
	
	</section>

</div>