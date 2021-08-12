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
/* 첨부파일 버튼 스타일 재정의*/
.aui-grid-button-renderer {
     width:100%;
     padding: 4px;
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
    headerText : '<spring:message code="pettyCashCustdn.costCentrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : '<spring:message code="pettyCashCustdn.custdn" />'
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="pettyCashCustdn.custdnName" />',
    style : "aui-grid-user-custom-left"
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
    labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
        var myString = value;
        // 로직 처리
        // 여기서 value 를 원하는 형태로 재가공 또는 포매팅하여 반환하십시오.
        if(FormUtil.isEmpty(myString)) {
            myString = '<spring:message code="invoiceApprove.noAtch.msg" />';
        }
        return myString;
     }, 
    renderer : {
        type : "ButtonRenderer",
        onclick : function(rowIndex, columnIndex, value, item) {
            console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId + " atchFileId : " + item.atchFileId);
            if(item.fileCnt > 1) {
                atchFileGrpId = item.atchFileGrpId;
                fn_fileListPop(item.atchFileGrpId);
            } else {
            	if(item.fileCnt == 1) {
                    var data = {
                            atchFileGrpId : item.atchFileGrpId,
                            atchFileId : item.atchFileId
                    };
                    if(item.fileExtsn == "jpg" || item.fileExtsn == "png" || item.fileExtsn == "gif") {
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
                            console.log("/file/fileDownWeb.do?subPath=" + fileSubPath
                                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                            window.open("/file/fileDownWeb.do?subPath=" + fileSubPath
                                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                        });
                    }
                } else {
                	Common.alert('<spring:message code="invoiceApprove.notFoundAtch.msg" />');
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
    headerText : '<spring:message code="pettyCashCustdn.crtDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "crtUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "userName",
    headerText : '<spring:message code="pettyCashCustdn.creator" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "updDt",
    headerText : '<spring:message code="pettyCashCustdn.lastUpdateDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "updUserName",
    headerText : '<spring:message code="pettyCashCustdn.lastUpdUser" />',
    style : "aui-grid-user-custom-left"
}
];

//그리드 속성 설정
var pettyCashCustdnGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 헤더 높이 지정
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var pettyCashCustdnGridID;

$(document).ready(function () {
	pettyCashCustdnGridID = AUIGrid.create("#pettyCashCustdn_grid_wrap", pettyCashCustdnColumnLayout, pettyCashCustdnGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#search_createUser_btn").click(fn_searchUserIdPop);
    $("#registration_btn").click(fn_newCustodianPop);
    $("#edit_btn").click(fn_viewCustodianPop);
    $("#delete_btn").click(fn_deleteCustodianPop);
    
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

function fn_fileListPop(atchFileGrpId) {
    var data = {
            atchFileGrpId : atchFileGrpId
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_setGridData(gridId, data) {
    console.log(data);
    AUIGrid.setGridData(gridId, data);
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popSupplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {pop:"pop",accGrp:"VM10"}, null, true, "supplierSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
    
    if(fn_checkEmpty()){
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(!FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashCustdn.alreadyRgist.msg" />');
                $("#newCostCenter").val("");
                $("#newCostCenterText").val("");
                $("#newMemAccId").val("");
                $("#newMemAccName").val("");
                $("#custdnNric").val("");
                $("#bankCode").val("");
                $("#bankName").val("");
                $("#bankAccNo").val("");
            } else {
            	// USER_NRIC GET
                Common.ajax("POST", "/eAccounting/pettyCash/selectUserNric.do", {memAccId:$("#search_memAccId").val()}, function(result) {
                    console.log(result);
                    $("#custdnNric").val(result.data.userNric);
                });
            }
        });
    }
}

function fn_setPopSupplier() {
    $("#newMemAccId").val($("#search_memAccId").val());
    $("#newMemAccName").val($("#search_memAccName").val());
    $("#bankCode").val($("#search_bankCode").val());
    $("#bankName").val($("#search_bankName").val());
    $("#bankAccNo").val($("#search_bankAccNo").val());
    
    if(fn_checkEmpty()){
        var data = {
                memAccId : $("#newMemAccId").val(),
                costCentr : $("#newCostCenter").val()
        };
        Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
            console.log(result);
            console.log(FormUtil.isEmpty(result.data));
            if(!FormUtil.isEmpty(result.data)) {
                Common.alert('<spring:message code="pettyCashCustdn.alreadyRgist.msg" />');
                $("#newCostCenter").val("");
                $("#newCostCenterText").val("");
                $("#newMemAccId").val("");
                $("#newMemAccName").val("");
                $("#custdnNric").val("");
                $("#bankCode").val("");
                $("#bankName").val("");
                $("#bankAccNo").val("");
            } else {
                // USER_NRIC GET
                Common.ajax("POST", "/eAccounting/pettyCash/selectUserNric.do", {memAccId:$("#search_memAccId").val()}, function(result) {
                    console.log(result);
                    $("#custdnNric").val(result.data.userNric);
                });
            }
        });
    }
}

function fn_setCostCenterEvent() {
    $("#newCostCenter").change(function(){
        var costCenter = $(this).val();
        console.log(costCenter);
        if(!FormUtil.isEmpty(costCenter)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectCostCenter.do?_cacheId=" + Math.random(), {costCenter:costCenter}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newCostCenterText").val(row.costCenterText);
                }
                
                if(fn_checkEmpty()){
                    var data = {
                            memAccId : $("#newMemAccId").val(),
                            costCentr : $("#newCostCenter").val()
                    };
                    Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
                        console.log(result);
                        console.log(FormUtil.isEmpty(result.data));
                        if(!FormUtil.isEmpty(result.data)) {
                            Common.alert('<spring:message code="pettyCashCustdn.alreadyRgist.msg" />');
                            $("#newCostCenter").val("");
                            $("#newCostCenterText").val("");
                            $("#newMemAccId").val("");
                            $("#newMemAccName").val("");
                            $("#custdnNric").val("");
                            $("#bankCode").val("");
                            $("#bankName").val("");
                            $("#bankAccNo").val("");
                        } else {
                            // USER_NRIC GET
                            Common.ajax("POST", "/eAccounting/pettyCash/selectUserNric.do", {memAccId:$("#search_memAccId").val()}, function(result) {
                                console.log(result);
                                $("#custdnNric").val(result.data.userNric);
                            });
                        }
                    });
                }
            });
        }
   }); 
}

function fn_setSupplierEvent() {
    $("#newMemAccId").change(function(){
        var memAccId = $(this).val();
        console.log(memAccId);
        if(!FormUtil.isEmpty(memAccId)){
            Common.ajax("GET", "/eAccounting/webInvoice/selectSupplier.do?_cacheId=" + Math.random(), {memAccId:memAccId}, function(result) {
                console.log(result);
                if(result.length > 0) {
                    var row = result[0];
                    console.log(row);
                    $("#newMemAccName").val(row.memAccName);
                    $("#bankCode").val(row.bankCode);
                    $("#bankName").val(row.bankName);
                    $("#bankAccNo").val(row.bankAccNo);
                }
                
                if(fn_checkEmpty()){
                    var data = {
                            memAccId : $("#newMemAccId").val(),
                            costCentr : $("#newCostCenter").val()
                    };
                    Common.ajax("POST", "/eAccounting/pettyCash/selectCustodianInfo.do", data, function(result) {
                        console.log(result);
                        console.log(FormUtil.isEmpty(result.data));
                        if(!FormUtil.isEmpty(result.data)) {
                            Common.alert('<spring:message code="pettyCashCustdn.alreadyRgist.msg" />');
                            $("#newCostCenter").val("");
                            $("#newCostCenterText").val("");
                            $("#newMemAccId").val("");
                            $("#newMemAccName").val("");
                            $("#custdnNric").val("");
                            $("#bankCode").val("");
                            $("#bankName").val("");
                            $("#bankAccNo").val("");
                        } else {
                            // USER_NRIC GET
                            Common.ajax("POST", "/eAccounting/pettyCash/selectUserNric.do", {memAccId:$("#search_memAccId").val()}, function(result) {
                                console.log(result);
                                $("#custdnNric").val(result.data.userNric);
                            });
                        }
                    });
                }
            });
        }
   }); 
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
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

function fn_selectCustodianList() {
    Common.ajax("GET", "/eAccounting/pettyCash/selectCustodianList.do?_cacheId=" + Math.random(), $("#form_pettyCashCustdn").serializeJSON(), function(result) {
        console.log(result);
        AUIGrid.setGridData(pettyCashCustdnGridID, result);
    });
}

function fn_newCustodianPop() {
    Common.popupDiv("/eAccounting/pettyCash/newCustodianPop.do", null, null, true, "newCustodianPop");
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
    	Common.alert('<spring:message code="pettyCashCustdn.costCentr.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newMemAccId").val())) {
        Common.alert('<spring:message code="pettyCashCustdn.custdn.msg" />');
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}

function fn_viewCustodianPop() {
	var data = {
			costCentr : costCentr,
			memAccId : memAccId
	}
    Common.popupDiv("/eAccounting/pettyCash/viewCustodianPop.do", data, null, true, "viewCustodianPop");
}

function fn_deleteCustodianPop() {
    Common.popupDiv("/eAccounting/pettyCash/removeRegistMsgPop.do", null, null, true, "registMsgPop");
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="pettyCashCustdn.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectCustodianList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_pettyCashCustdn">
<input type="hidden" id="costCenterText" name="costCentrName">
<input type="hidden" id="memAccName" name="memAccName">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCentr"/><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="pettyCashCustdn.lastUpdUser" /></th>
	<td><input type="text" title="" placeholder="" class="" id="createUser" name="crtUserId"/><a href="#" class="search_btn" id="search_createUser_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row"><spring:message code="pettyCashCustdn.custdn" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId" /><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="pettyCashCustdn.lastUpdate" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
	<span><spring:message code="webInvoice.to" /></span>
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
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_grid"><a href="#" id="delete_btn"><spring:message code="pettyCashCustdn.remove" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="edit_btn"><spring:message code="pettyCashCustdn.edit" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="pettyCashCustdn.newCustdn" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap" id="pettyCashCustdn_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->