<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
var newGridID;
	
	$(document).ready(function(){
		newGridID = GridCommon.createAUIGrid("grid_wrap_new", newColumn,null,gridPros);
		
		// HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
        function checkHTML5Brower() {
            var isCompatible = false;
            if (window.File && window.FileReader && window.FileList && window.Blob) {
                isCompatible = true;
            }
            return isCompatible;
        }
		
        $("#uploadfile").on('change', function(evt) {
            if (!checkHTML5Brower()) {
                   // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
                   // 파일 내용 읽어 반환시켜 그리드에 적용.
                   commitFormSubmit();
                   //alert("브라우저가 HTML5 를 지원하지 않습니다.");
               } else {
                   var data = null;
                   var file = evt.target.files[0];
                   if (typeof file == "undefined") {
                       return;
                   }
                   var reader = new FileReader();
                   //reader.readAsText(file); // 파일 내용 읽기
                   reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
                   reader.onload = function(event) {
                       if (typeof event.target.result != "undefined") {
                           // 그리드 CSV 데이터 적용시킴
                           AUIGrid.setCsvGridData(newGridID, event.target.result, false);
                       } else {
                    	   Common.alert('<spring:message code="sys.common.alert.upload.noDate"/>');
                       }
                   };
                   reader.onerror = function() {
                	   Common.alert("<spring:message code='sys.common.alert.upload.unable' arguments='"+file.fileName+"' htmlEscape='false'/>");
                   };
               }
       });
	});
	
var gridPros = {
	        editable: false,
	        showStateColumn: false
	};
	var newColumn=[
	      {dataField:"ctCode", headerText:"ctCode"},
	      {dataField:"perfac", headerText:"perfac"},
	      {dataField:"basicAllowance", headerText:"basicAllowance"},
	      {dataField:"adjust", headerText:"adjust"},
	      {dataField:"phoneSubsidy", headerText:"phoneSubsidy"}
	];
	
	
	function fn_uploadFile() {
		
	    var fileNm = $("#uploadfile").val();
		
	    if(fileNm.substr(fileNm.indexOf("."),fileNm.length) != ".csv"){
	    	Common.alert('<spring:message code="sys.common.alert.upload.csv"/>');
            return;
	    }else{
	    	
	    	//param data array
	        var data = {};

	        var gridList = AUIGrid.getGridData(newGridID);       //그리드 데이터
	        
	        //array에 담기        
	        if(gridList.length > 0) {
	        	var num_check=/^[-\.0-9]*$/;
	        	
	        	for (var i = 1; i < gridList.length-1; i++) {
	        		var CTCode = (gridList[i])[0];
	        		var Perfac = (gridList[i])[1];
	        		var BasicAllowance = (gridList[i])[2];
	        		var Adjust = (gridList[i])[3];
	        		var PhoneSubsidy = (gridList[i])[4];
	        	    
	        		if(CTCode == null || CTCode == ""){
                        Common.alert("<spring:message code='sys.common.alert.validation' arguments='CTCode' htmlEscape='false'/>");return;
                    }else if(Perfac == null || Perfac == "" ||!(num_check.test(Perfac))){
                        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Perfac' htmlEscape='false'/>");return;
                    }else if(BasicAllowance == null || BasicAllowance == "" ||!(num_check.test(BasicAllowance))){
                        Common.alert("<spring:message code='sys.common.alert.validation' arguments='BasicAllowance' htmlEscape='false'/>");return;
                    }else if(Adjust == null || Adjust == "" ||!(num_check.test(Adjust))){
                        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Adjust' htmlEscape='false'/>");return;
                    }else if(PhoneSubsidy == null || PhoneSubsidy == "" ||!(num_check.test(PhoneSubsidy))){
                        Common.alert("<spring:message code='sys.common.alert.validation' arguments='PhoneSubsidy' htmlEscape='false'/>");return;
                    }
	        	
	        	}
	        	
	            data.all = gridList;
	        }  else {
	        	Common.alert('<spring:message code="sys.common.alert.upload.csv"/>');
	            return;
	        }
	        
	        //Ajax 호출
	        Common.ajax("POST", "/commission/calculation/ctUploadFile", data, function(result) {
	        	Common.alert('<spring:message code="sys.msg.success"/>');
	            
	            document.myForm.reset();
	        },  function(jqXHR, textStatus, errorThrown) {
	            try {
	                console.log("status : " + jqXHR.status);
	                console.log("code : " + jqXHR.responseJSON.code);
	                console.log("message : " + jqXHR.responseJSON.message);
	                console.log("detailMessage : "
	                        + jqXHR.responseJSON.detailMessage);
	            } catch (e) {
	                console.log(e);
	            }
	            Common.alert("<spring:message code='sys.common.alert.error.ajaxSubmit' arguments='"+jqXHR.responseJSON.message+"' htmlEscape='false'/>");
	        });
	    }
	    
		
	}
	
</script>


	<section id="content"><!-- content start -->
		<ul class="path">
			<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
			<li><spring:message code='commission.text.head.commission'/></li>
			<li><spring:message code='commission.text.head.report'/></li>
			<li><spring:message code='commission.text.head.ctReport'/></li>
		</ul>
		
		<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code='commission.title.uploadCT'/></h2>
		</aside><!-- title_line end -->
	
	
		<section class="search_table"><!-- search_table start -->
			<form name="myForm" id="myForm">       
				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:130px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><spring:message code='commission.text.search.file'/></th>
							<td>
								<div class="auto_file"><!-- auto_file start -->
								     <input type="file" title="file add"  id="uploadfile" name="uploadfile"/>
								</div><!-- auto_file end -->
							</td>
						</tr>
					</tbody>
				</table><!-- table end -->
			</form>
		
		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();">Upload File</a></p></li>
		    <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/CTCommUploadFormat.csv">Download Format</a></p></li>
		</ul>
		<!-- grid_wrap start -->
	    <article id="grid_wrap_new" class="grid_wrap" style="display:none;"></article>
	    <!-- grid_wrap end -->
		</section><!-- search_table end -->
	
	</section><!-- content end -->

<hr />

</body>
</html>