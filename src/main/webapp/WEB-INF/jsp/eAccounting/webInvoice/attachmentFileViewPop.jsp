<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var attaListGridID;
var attaListGridData = new Array();
<c:forEach var="data" items="${attachList}">
var obj = {
        atchFileGrpId : "${data.atchFileGrpId}"
        ,atchFileId : "${data.atchFileId}"
        ,atchFileName : "${data.atchFileName}"
        ,fileSubPath : "${data.fileSubPath}"
        ,physiclFileName : "${data.physiclFileName}"
        ,fileExtsn : "${data.fileExtsn}"
        ,taxCode : "${data.taxCode}"
        ,fileSize : "${data.fileSize}"
};
attaListGridData.push(obj);
</c:forEach>
var attaListColumnLayout = [ {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileName",
    headerText : '<spring:message code="newWebInvoice.attachment" />'
}, {
    dataField : "fileExtsn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}
];

//그리드 속성 설정
var attaListGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
	attaListGridID = AUIGrid.create("#attaList_grid_wrap", attaListColumnLayout, attaListGridPros);
	
	AUIGrid.bind(attaListGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log(event.item)
                var data = {
                            atchFileGrpId : event.item.atchFileGrpId,
                            atchFileId : event.item.atchFileId
                    };
                if(event.item.fileExtsn == "jpg" || event.item.fileExtsn == "png") {
                    // TODO View
                	Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                        console.log(result);
                        var fileSubPath = result.fileSubPath;
                        fileSubPath = fileSubPath.replace('\', '/'');
                        console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                        window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                    });
                } else {
                	Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                        console.log(result);
                        var fileSubPath = result.fileSubPath;
                        fileSubPath = fileSubPath.replace('\', '/'');
                        console.log("/file/fileDown.do?subPath=" + fileSubPath
                                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                        window.open("/file/fileDown.do?subPath=" + fileSubPath
                            + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                    });
                }
            });
    
	fn_setGridData(attaListGridID, attaListGridData);
});
</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="attachFileView.title" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<article class="grid_wrap" id="attaList_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->