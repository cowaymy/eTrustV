<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myClaimFileDownGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

//Grid Properties 설정
var gridPros = {
		// 편집 가능 여부 (기본값 : false)
		editable : false,        
		// 상태 칼럼 사용
		showStateColumn : false,
		// 기본 헤더 높이 지정
		headerHeight : 35,
		
		softRemoveRowMode:false

};

// AUIGrid 칼럼 설정
var claimFileDownloadColumnLayout = [ 
	{dataField : "filePath",headerText : "File Path",width : 240 , editable : false},
	{dataField : "fileName",headerText : "File Name",width : 300 , editable : false},
	{
		dataField : "fileFullPath",
		headerText : "download",
		width : 160,
		filter : {
			showIcon : false
		},
		renderer : { // HTML 템플릿 렌더러 사용
			type : "TemplateRenderer"
		},
		// dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
		labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
			if(!value)	return "";

			return "<a href='" + "${pageContext.request.contextPath}/resources/"+value+"'> download </a>";
		}
	}
];


$(document).ready(function(){
	
	myClaimFileDownGridID = GridCommon.createAUIGrid("grid_claim_file_wrap", claimFileDownloadColumnLayout,null,gridPros);
	searchClaimFileDownloadList();

	 // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myClaimFileDownGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
		fn_fileDownload();
    });
});

// ajax list 조회.
function searchClaimFileDownloadList(){
	Common.ajax("GET","/payment/selectClaimFileDown.do",$("#_claimFileDownForm").serialize(), function(result){    		
		AUIGrid.setGridData(myClaimFileDownGridID, result);

	});
}

function fn_atchViewDown(atchFileName, fileSubPath, physiclFileName) {
	
    	

	
           var fileSubPath = fileSubPath;
           fileSubPath = fileSubPath.replace('\', '/'');
           console.log("/file/fileDownClaim.do?subPath=" + fileSubPath
                   + "&fileName=" + physiclFileName + "&orignlFileNm=" + atchFileName);
           window.open("/file/fileDownClaim.do?subPath=" + fileSubPath
               + "&fileName=" + physiclFileName + "&orignlFileNm=" + atchFileName);
      
}


//View Claim Pop-UP
function fn_fileDownload(){
	

		
		var selectedItem = AUIGrid.getSelectedIndex(myClaimFileDownGridID);
	    
	    if (selectedItem[0] > -1){
		
	    	var fileSubPath = AUIGrid.getCellValue(myClaimFileDownGridID, selectedGridValue, "filePath");
	        var fileName = AUIGrid.getCellValue(myClaimFileDownGridID, selectedGridValue, "fileName");
	       
	         var fileSubPath = fileSubPath;
           fileSubPath = fileSubPath.replace('\', '/'');
           console.log("/file/fileDownClaim.do?subPath=" + fileSubPath
                   + "&fileName=" + fileName + "&orignlFileNm=" + fileName);
           window.open("/file/fileDownClaim.do?subPath=" + fileSubPath
               + "&fileName=" + fileName + "&orignlFileNm=" + fileName);
	       
			
        }else{
             Common.alert("<spring:message code='pay.alert.noClaim'/>");
        }
	
}



</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Claim File Download</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->
		

		<!-- search_table start -->
		<section class="search_table">
			<form name="_claimFileDownForm" id="_claimFileDownForm"  method="post">
				<input id="ctrlId" name="ctrlId" value="${ctrlId}" type="hidden" />

				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width:160px" />
						<col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Batch ID</th>
							<td>${ctrlId}</td>							
						</tr>
					</tbody>
				</table>
			</form>
		</section>

		<!-- grid_wrap start -->
	    <article class="grid_wrap">
	        <div id="grid_claim_file_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
	    </article>
	    <!-- grid_wrap end -->
	</section>
</div>