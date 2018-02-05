<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
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
var clickType = "";
var crditCardSeq = 0;
var checkRemoved = false;
var mgmtColumnLayout = [ {
    dataField : "crditCardSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserName",
    headerText : '<spring:message code="crditCardMgmt.cardholderBrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crditCardNo",
    headerText : '<spring:message code="crditCardMgmt.crditCardNo" />'
}, {
    dataField : "chrgUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserName",
    headerText : '<spring:message code="crditCardMgmt.chargeBrName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentr",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="crditCardMgmt.chargeBrDepart" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crtDt",
    headerText : '<spring:message code="pettyCashCustdn.crtDt" />',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "updDt",
    headerText : '<spring:message code="pettyCashCustdn.lastUpdateDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
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
    dataField : "crditCardStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}
];

//그리드 속성 설정
var mgmtGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
 // 헤더 높이 지정
    headerHeight : 40,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var mgmtGridID;

$(document).ready(function () {
	mgmtGridID = AUIGrid.create("#mgmt_grid_wrap", mgmtColumnLayout, mgmtGridPros);
    
    $("#search_holder_btn").click(function() {
    	clickType = "holder";
    	fn_searchUserIdPop();
    });
    $("#search_charge_btn").click(function() {
    	clickType = "charge";
    	fn_searchUserIdPop();
    });
    $("#search_depart_btn").click(fn_costCenterSearchPop);
    $("#registration_btn").click(fn_newMgmtPop);
    $("#edit_btn").click(fn_viewMgmtPop);
    $("#delete_btn").click(fn_removeRegistMsgPop);
    
    AUIGrid.bind(mgmtGridID, "cellClick", function( event ) 
            {
                console.log("cellClick rowIndex : " + event.rowIndex + ", cellClick : " + event.columnIndex + " clicked");
                console.log("cellClick crditCardSeq : " + event.item.crditCardSeq);
                crditCardSeq = event.item.crditCardSeq;
                if(event.item.crditCardStusCode == "R") {
                	checkRemoved = true;
                } else {
                	checkRemoved = false;
                }
            });
    
    $("#crditCardStus").multipleSelect("checkAll");
    
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

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", {callPrgm:"NRIC_VISIBLE"}, null, true);
}

// 그리드에 set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            console.log(memInfo.memCode);
            console.log(memInfo.name);
            console.log(clickType);
            if(clickType == "holder") {
            	$("#crditCardUserId").val(memInfo.memCode);
            	$("#crditCardUserName").val(memInfo.name);
            } else if(clickType == "charge") {
            	$("#chrgUserId").val(memInfo.memCode);
                $("#chrgUserName").val(memInfo.name);
            } else if(clickType == "newHolder") {
                $("#newCrditCardUserId").val(memInfo.memCode);
                $("#newCrditCardUserName").val(memInfo.name);
            } else if(clickType == "newCharge") {
                $("#newChrgUserId").val(memInfo.memCode);
                $("#newChrgUserName").val(memInfo.name);
            }
        }
    });
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_popCostCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", {pop:"pop"}, null, true, "costCenterSearchPop");
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_setPopCostCenter() {
    $("#newCostCenter").val($("#search_costCentr").val());
    $("#newCostCenterText").val($("#search_costCentrName").val());
}

function fn_selectCrditCardMgmtList() {
    Common.ajax("GET", "/eAccounting/creditCard/selectCrditCardMgmtList.do?_cacheId=" + Math.random(), $("#form_mgmt").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(mgmtGridID, result);
    });
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

function fn_newMgmtPop() {
    Common.popupDiv("/eAccounting/creditCard/newMgmtPop.do", {callType:"new"}, null, true, "newMgmtPop");
}

function fn_checkEmpty() {
    var checkResult = true;
    if(FormUtil.isEmpty($("#newCrditCardUserName").val())) {
        Common.alert('<spring:message code="crditCardMgmt.cardholder.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newChrgUserName").val())) {
        Common.alert('<spring:message code="crditCardMgmt.chargeName.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#newCostCenter").val())) {
        Common.alert('<spring:message code="crditCardMgmt.chargeDepart.msg" />');
        checkResult = false;
        return checkResult;
    }
    if(FormUtil.isEmpty($("#crditCardNo1").val()) || FormUtil.isEmpty($("#crditCardNo2").val()) || FormUtil.isEmpty($("#crditCardNo3").val()) || FormUtil.isEmpty($("#crditCardNo4").val())) {
        Common.alert('<spring:message code="crditCardMgmt.crditCardNo.msg" />');
        checkResult = false;
        return checkResult;
    }
    return checkResult;
}

function fn_viewMgmtPop() {
	if(crditCardSeq == 0) {
		Common.alert('<spring:message code="crditCardMgmt.selectData.msg" />');
	} else {
		var data = {
	            crditCardSeq : crditCardSeq,
	            callType : "view"
	    };
	    Common.popupDiv("/eAccounting/creditCard/viewMgmtPop.do", data, null, true, "viewMgmtPop");
	}
}

function fn_removeRegistMsgPop() {
    if(crditCardSeq == 0) {
        Common.alert('<spring:message code="crditCardMgmt.selectData.msg" />');
    } else {
    	if(checkRemoved) {
    		Common.alert('<spring:message code="crditCardMgmt.alreadyDel.msg" />');
    	} else {
    		Common.popupDiv("/eAccounting/creditCard/removeRegistMsgPop.do", null, null, true, "registMsgPop");
    	}
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
            });
        }
   }); 
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="crditCardMgmt.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectCrditCardMgmtList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_mgmt">
<input type="hidden" id="crditCardUserId" name="crditCardUserId">
<input type="hidden" id="chrgUserId" name="chrgUserId">
<input type="hidden" id="costCenterText" name="costCentrName">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="crditCardMgmt.cardholderName" /></th>
	<td><input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="crditCardUserName" name="crditCardUserName"/><a href="#" class="search_btn" id="search_holder_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="crditCardMgmt.crditCardNo" /></th>
	<td><input type="text" title="" placeholder="Credit card No" class="" id="crditCardNo" name="crditCardNo" autocomplete=off/></td>
</tr>
<tr>
	<th scope="row"><spring:message code="crditCardMgmt.chargeName" /></th>
	<td><input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="chrgUserName" name="chrgUserName" /><a href="#" class="search_btn" id="search_charge_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="crditCardMgmt.chargeDepart" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCentr"/><a href="#" class="search_btn" id="search_depart_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
	<th scope="row"><spring:message code="crditCardMgmt.lastUpdateDt" /></th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
	<span><spring:message code="webInvoice.to" /></span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row"><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="multy_select" multiple="multiple" id="crditCardStus" name="crditCardStus">
		<option value="A"> <spring:message code="crditCardMgmt.active" /></option>
		<option value="R"> <spring:message code="crditCardMgmt.removed" /></option>
	</select>
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
	<li><p class="btn_grid"><a href="#" id="registration_btn"><spring:message code="crditCardMgmt.newRgistration" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap" id="mgmt_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->