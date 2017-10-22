<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var costCentr;
var memAccId;
var pettyCashCustdnColumnLayout = [ {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.costCenter" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="approveLine.name" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : 'Custodian'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="approveLine.name" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "headDeptFlag",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "",
    headerText : 'Department',
    style : "aui-grid-user-custom-left",
    labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
    	   var myString = "";
    	   // 로직 처리
    	   // 여기서 value 를 원하는 형태로 재가공 또는 포매팅하여 반환하십시오.
    	   if(item.headDeptFlag == "Y") {
    		   myString = "Head Department";
    	   } else {
    		   myString = "N/A"
    	   }
    	   return myString;
    	} 
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileName",
    headerText : '<spring:message code="newWebInvoice.attachment" />',
    width : 200,
    renderer : {
        type : "ButtonRenderer",
        onclick : function(rowIndex, columnIndex, value, item) {
            console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId + " atchFileId : " + item.atchFileId);
            if(item.fileCnt > 1) {
                atchFileGrpId = item.atchFileGrpId;
                fn_fileListPop();
            } else {
                var data = {
                        atchFileGrpId : item.atchFileGrpId,
                        atchFileId : item.atchFileId
                };
                if(item.fileExtsn == "jpg") {
                    // TODO View
                    console.log(data);
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
            }
        }
    }
}, {
    dataField : "fileExtsn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "fileCnt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crtDt",
    headerText : 'Create Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "updDt",
    headerText : 'Update Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "crtUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "userName",
    headerText : 'Creator',
    style : "aui-grid-user-custom-left"
}
];

//그리드 속성 설정
var pettyCashCustdnGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20
};

var pettyCashCustdnGridID;

$(document).ready(function () {
	pettyCashCustdnGridID = AUIGrid.create("#pettyCashCustdn_grid_wrap", pettyCashCustdnColumnLayout, pettyCashCustdnGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#search_createUser_btn").click(fn_searchUserIdPop);
    $("#registration_btn").click(fn_newCustodianPop);
    $("#edit_btn").click(fn_viewCustodianPop);
    
    AUIGrid.bind(pettyCashCustdnGridID, "cellClick", function( event ) 
            {
                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellClick costCentr : " + event.item.costCentr + " CellClick custdn(memAccId) : " + event.item.memAccId);
                costCentr = event.item.costCentr;
                memAccId = event.item.memAccId;
            });
    
    fn_setToDay();
});

function fn_setToDay() {
    var today = new Date();
    
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }
    
    today = dd + "/" + mm + "/" + yyyy;
    $("#startDt").val(today)
    $("#endDt").val(today)
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", null, null, true);
}

//set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            // TODO createUser set
            $("#createUser").val(memInfo.memCode);
        }
    });
}

function fn_selectPettyCashList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectPettyCashList.do", $("#form_pettyCashCustdn").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashCustdnGridID, result);
    });
}

function fn_newCustodianPop() {
    Common.popupDiv("/eAccounting/pettyCash/newCustodianPop.do", null, null, true, "newCustodianPop");
}

function fn_viewCustodianPop() {
	var data = {
			costCentr : costCentr,
			memAccId : memAccId
	}
    Common.popupDiv("/eAccounting/pettyCash/viewCustodianPop.do", data, null, true, "viewCustodianPop");
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Petty Cash Custodian Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectPettyCashList()"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashCustdn">
<input type="hidden" id="costCenter" name="costCentr">
<input type="hidden" id="memAccId" name="memAccId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Cost Center</th>
	<td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCentrName"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Creator</th>
	<td><input type="text" title="" placeholder="" class="" id="createUser" name="crtUserId"/><a href="#" class="search_btn" id="search_createUser_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Custodian</th>
	<td><input type="text" title="" placeholder="" class="" id="memAccName" name="memAccName" /><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Last Update</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt" /></p>
	</div><!-- date_set end -->
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">Remove</a></p></li>
	<li><p class="btn_grid"><a href="#" id="edit_btn">Edit</a></p></li>
	<li><p class="btn_grid"><a href="#" id="registration_btn">New Custodian</a></p></li>
</ul>

<article class="grid_wrap" id="pettyCashCustdn_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->