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
</style>
<script type="text/javascript">
var clickType = "";
var mgmtColumnLayout = [ {
    dataField : "crditCardSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "crditCardUserName",
    headerText : 'Credit cardholder<br>name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crditCardNo",
    headerText : 'Credit card no.'
}, {
    dataField : "chrgUserId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "chrgUserName",
    headerText : 'Person-in-charge<br>name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentr",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "costCentrName",
    headerText : 'Person-in-charge<br>department',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "crtDt",
    headerText : 'Create Date',
    dataType : "date",
    formatString : "mm/yyyy"
}, {
    dataField : "updDt",
    headerText : 'Last Update<br>Date',
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
    headerHeight : 40
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
    $("#edit_btn").click();
    $("#delete_btn").click();
    
    AUIGrid.bind(mgmtGridID, "cellClick", function( event ) 
            {
                console.log("cellClick rowIndex : " + event.rowIndex + ", cellClick : " + event.columnIndex + " clicked");
                console.log("cellClick crditCardSeq : " + event.item.crditCardSeq);
                
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
    Common.popupDiv("/common/memberPop.do", null, null, true);
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
    Common.ajax("GET", "/eAccounting/creditCard/selectCrditCardMgmtList.do", $("#form_mgmt").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(mgmtGridID, result);
    });
}

function fn_newMgmtPop() {
    Common.popupDiv("/eAccounting/creditCard/newMgmtPop.do", {callType:"new"}, null, true, "newMgmtPop");
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
<h2>Credit Card Management</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectCrditCardMgmtList()"><span class="search"></span>Search</a></p></li>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_mgmt">
<input type="hidden" id="crditCardUserId" name="crditCardUserId">
<input type="hidden" id="chrgUserId" name="chrgUserId">
<input type="hidden" id="costCenter" name="costCentr">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:210px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Credit cardholder name</th>
	<td><input type="text" title="" placeholder="" class="" id="crditCardUserName" name="crditCardUserName"/><a href="#" class="search_btn" id="search_holder_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Credit card no.</th>
	<td><input type="text" title="" placeholder="Credit card No" class="" id="crditCardNo" name="crditCardNo"/></td>
</tr>
<tr>
	<th scope="row">Person-in-charge name</th>
	<td><input type="text" title="" placeholder="" class="" id="chrgUserName" name="chrgUserName" /><a href="#" class="search_btn" id="search_charge_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Person-in-charge department</th>
	<td><input type="text" title="" placeholder="" class="" id="costCenterText" name="costCentrName"/><a href="#" class="search_btn" id="search_depart_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
	<th scope="row">Last Update Date</th>
	<td>

	<div class="date_set"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
	</div><!-- date_set end -->

	</td>
	<th scope="row">Status</th>
	<td>
	<select class="multy_select" multiple="multiple" id="crditCardStus" name="crditCardStus">
		<option value="A"> Active</option>
		<option value="R"> Removed</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="delete_btn">Remove</a></p></li>
	<li><p class="btn_grid"><a href="#" id="edit_btn">Edit</a></p></li>
	<li><p class="btn_grid"><a href="#" id="registration_btn">New Registration</a></p></li>
</ul>

<article class="grid_wrap" id="mgmt_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->