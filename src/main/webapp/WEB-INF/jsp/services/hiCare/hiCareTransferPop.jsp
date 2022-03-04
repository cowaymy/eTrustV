<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javaScript">
var MEM_TYPE = '${SESSION_INFO.userTypeId}';

var resGrid;
var reqGrid;

var rescolumnLayout = [ {
    dataField : "rnum",
    headerText : "<spring:message code='log.head.rnum'/>",
    width : 130,
    height : 30,
    visible:false
}, {
    dataField : "serialNo",
    headerText : "Serial No.",
    width : 150,
    height : 30,
    editable : false
}, {
    dataField : "model",
    headerText : "model",
    width : 100,
    height : 30,
    editable : false
}, {
    dataField : "model1",
    headerText : "model1",
    width : 100,
    height : 30,
    visible:false
}, {
    dataField : "status",
    headerText : "Status",
    width : 80,
    height : 30,
    editable : false
}, {
    dataField : "condition",
    headerText : "Condition",
    width : 100,
    height : 30,
    editable : false
} ];

var reqcolumnLayout = [ {
    dataField : "rnum",
    headerText : "<spring:message code='log.head.rnum'/>",
    width : 130,
    height : 30,
    visible:false
}, {
    dataField : "serialNo",
    headerText : "Serial No.",
    width : 150,
    height : 30,
    editable : false
}, {
    dataField : "model",
    headerText : "model",
    width : 100,
    height : 30,
    editable : false
}, {
    dataField : "model1",
    headerText : "model1",
    width : 100,
    height : 30,
    visible:false
}, {
    dataField : "status",
    headerText : "Status",
    width : 80,
    height : 30,
    editable : false
}, {
    dataField : "condition",
    headerText : "Condition",
    width : 100,
    height : 30,
    editable : false
} ];

var resop = {
    rowIdField : "rnum",
    showRowCheckColumn : true,
    usePaging : true,
    useGroupingPanel : false,
    Editable : false
};
var reqop = {
    usePaging : true,
    useGroupingPanel : false,
    Editable : false
};

resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout, "", resop);
reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout, "", reqop);

var conditionOption = [{"codeId": "33","codeName": "New"},{"codeId": "111","codeName": "Used"}];
var statusOption = [{"codeId": "1","codeName": "Active"}];

$(document).ready(function(){

	$("#temp2").hide();

	doDefCombo(conditionOption, '' ,'tcondition', 'M', 'f_multiCombo');
	doDefCombo(statusOption, '' ,'tstatus', 'M', 'f_multiCombo');
	doGetCombo('/common/selectCodeList.do', '490', '', 'tcmbModel', 'M', 'f_multiCombo');
	doGetComboOrder('/common/selectCodeList.do', '498', 'CODE_ID', '', 'courier', 'S', ''); //Common Code
    $("#fromLoc option:eq(1)", '#hiCareTrfHeadForm').attr("selected", true);

    if(!(MEM_TYPE == "4" || MEM_TYPE == "6")){
        $('#fromLoc', '#hiCareTrfHeadForm').attr("disabled", true);
    }

	$("#rightbtn").click(function() {
        checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);

        var reqitms = AUIGrid.getGridData(reqGrid);
        var maxItem = 40;

        if (reqitms.length + checkedItems.length > maxItem){
            Common.alert("Maximum " + maxItem + " records per request.");
            return false;
        }

        var bool = true;
        if (checkedItems.length > 0) {
            var rowPos = "first";
            var item = new Object();
            var rowList = [];

            var boolitem = true;
            var k = 0;
            for (var i = 0; i < checkedItems.length; i++) {
                for (var j = 0; j < reqitms.length; j++) {
                    if (reqitms[j].serialNo == checkedItems[i].serialNo) {
                        boolitem = false;
                        break;
                    }
                }

                if (boolitem) {
                    rowList[k] = {
                    	serialNo : checkedItems[i].serialNo
                    	,model : checkedItems[i].model
                    	,status :checkedItems[i].status
                    	,condition : checkedItems[i].condition
                    	,model1 : checkedItems[i].model1
                    }
                    k++;
                }

                AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);
                boolitem = true;
            }

            AUIGrid.addRow(reqGrid, rowList, rowPos);
        }
    });

	$('#reqdel').click(function() {
        AUIGrid.removeRow(reqGrid, "selectedIndex");
        AUIGrid.removeSoftRows(reqGrid);
    });

	$('#save').click(function() {
        var dat = GridCommon.getEditData(reqGrid);
        dat.form = $("#hiCareTrfHeadForm").serializeJSON();

        if(f_validatation()){
        	Common.ajax("POST", "/services/hiCare/saveHiCareTransfer.do", dat, function(result) {
                if (result.code == '99') {
                    AUIGrid.clearGridData(reqGrid);
                    Common.alert(result.message, $("#searchItem").click());
                }
                else {
                    Common.alert("");
                    Common.alert("" + result.message + "</br> Created : " + result.data.transitNo, fn_scanClosePop);
                    AUIGrid.resetUpdatedItems(reqGrid, "all");
                }

            }, function(jqXHR, textStatus, errorThrown) {
                try {
                }
                catch (e) {
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        }else{
        	if(dat.add.length == 0){
        		   Common.alert("No record select for change.");
        	}
        }
    });
});

function f_multiCombo() {
    $(function() {
        $('#tcmbModel').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");
        $('#tcondition').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");
        $('#tstatus').change(function() {
        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '80%'
        }).multipleSelect("checkAll");
    });
}

//이벤트 정의
$(function(){

	$('#searchItem').click(function() {
        $("#sLocation").val($("#fromLoc").val());
        var param = $('#hiCareTrfItmForm').serialize();
        $.extend(param,
                {
            "cmbBranchCode":$("#fromLoc").val()
                }
                );
        SearchListAjax(param);
    });

	$('#fromLoc').click(function() {
		$("#cmbBranchCode",'#hiCareTrfItmForm').val($("#fromLoc").val());
    });
});

function SearchListAjax(param) {

    var url = "/services/hiCare/selectHiCareItemList";

    $.ajax({
        type : "POST",
        url : url + "?" + param,
        //url : "/stock/StockList.do",
        //data : param,
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        beforeSend : function(request) {
            Common.showLoader();
        },
        success : function(data) {
        	AUIGrid.setGridData(resGrid, data);
        },
        error : function(jqXHR, textStatus, errorThrown) {
            Common.setMsg("Fail ........ ");
        },
        complete : function() {
            Common.removeLoader();
        }
    });
}


$("#btnScanClose").click(function(){
    fn_scanClosePop();
});

function fn_scanClosePop(){
    $("#search").click();
    $('#transferPop').remove();
}

function f_validatation(){
	if ($("#fromLoc").val() == null || $("#fromLoc").val() == undefined || $("#fromLoc").val() == "") {
        Common.alert("Please select From Location.");
        return false;
    }

	if ($("#toLoc").val() == null || $("#toLoc").val() == undefined || $("#toLoc").val() == "") {
        Common.alert("Please select To Location.");
        return false;
    }

	if ($("#courier").val() == null || $("#courier").val() == undefined || $("#courier").val() == "") {
        Common.alert("Please select a Courier.");
        return false;
    }
	return true;
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Hi-Care - Transfer</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnScanClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
    <aside class="title_line"><!-- title_line start -->
    <ul class="right_btns">
    </ul>
    </aside><!-- title_line end -->
    <aside class="title_line">
        <h3>Transfer Information</h3>
    </aside>
    <form id="hiCareTrfHeadForm" name="hiCareTrfHeadForm" method="POST">
    <table class="type1">
        <caption>table</caption>
        <colgroup>
            <col style="width:150px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
            <tr id="type">
                <th scope="row">From Location</th>
                <td colspan="3">
	                <select id="fromLoc" name="fromLoc" class="w100p readOnly ">
	                    <option value="">Choose One</option>
	                        <c:forEach var="list" items="${fromBranchList}" varStatus="status">
	                            <option value="${list.codeId}">${list.codeName}</option>
	                        </c:forEach>
	                </select>
                </td>
            </tr>
            <tr>
                <th scope="row">To Location</th>
                <td colspan="3">
                <select id="toLoc" name="toLoc" class="w100p readOnly ">
                    <option value="">Choose One</option>
                        <c:forEach var="list" items="${toBranchList}" varStatus="status">
                            <option value="${list.codeId}">${list.codeName}</option>
                        </c:forEach>
                </select>
                </td>
            </tr>
            <tr>
                <th scope="row">Courier</th>
                <td colspan="3"><select class="w100p" id="courier" name="courier"></select></td>
            </tr>
            <input type="hidden" id="serialNoChg" />
        </tbody>
    </table>
    </form>

<section class="search_table">
    <aside class="title_line">
        <h3>Item Info</h3>
        <ul class="right_btns">
            <c:out value="${PAGE_AUTH}"></c:out>
            <li><p class="btn_blue2">
                <a id="searchItem"><spring:message code='sys.btn.search' /></a>
            </p></li>
        </ul>
    </aside>
    <form id="hiCareTrfItmForm" name="hiCareTrfItmForm" method="POST">
    <input type="hidden" id="sLocation" name="sLocation">
    <table class="type1">
        <caption>table</caption>
        <colgroup>
            <col style="width: 180px" />
                    <col style="width: *" />
                    <col style="width: 180px" />
                    <col style="width: *" />
        </colgroup>
        <tbody>
        <input type="text" id="temp2" name="temp2" placeholder="" class="w100p" />
        <tr>
                <th scope="row">Serial No.</th>
                <td colspan="2"><input type="text"  id="serialNo" name="serialNo" text-transform:uppercase;" class="w100p"/></td>
                <th scope="row">Model</th>
                <td colspan="2">
                    <select class="w100p" id="tcmbModel" name="tcmbModel"></select>
                </td>
            </tr>
            <tr>
                <th scope="row">Status</th>
                <td colspan="2">
	                <select class="w100p" id="tstatus" name="tstatus"></select>
                </td>
                <th scope="row">Condition</th>
                <td colspan="2">
	                <select class="w100p" id="tcondition" name="tcondition"></select>
                </td>
            </tr>
            <input type="hidden" id="serialNoChg" />
            <input type="hidden" id="cmbBranchCode" />
        </tbody>
    </table>
    </form>
</section>

<!------------------------------------------------------------------------------
    Content START
------------------------------------------------------------------------------->
<section class="search_result">
    <!-- search_result start -->

    <div class="divine_auto type2">
        <!-- divine_auto start -->

        <div style="width: 50%">
            <!-- 50% start -->

            <aside class="title_line">
                <!-- title_line start -->
                <h3>Hi-Care Serial No.</h3>
            </aside>
            <!-- title_line end -->

            <div class="border_box" style="height: 340px;">
                <!-- border_box start -->

                <article class="grid_wrap">
                    <!-- grid_wrap start -->
                    <div id="res_grid_wrap"></div>
                </article>
                <!-- grid_wrap end -->

            </div>
            <!-- border_box end -->

        </div>
        <!-- 50% end -->

        <div style="width: 50%">
            <!-- 50% start -->

            <aside class="title_line">
                <!-- title_line start -->
                <h3>Hi-Care To Transfer</h3>
                <ul class="right_btns">
                    <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
                    <!--     <li><p class="btn_grid"><a id="reqadd">ADD</a></p></li> -->
                    <li><p class="btn_grid">
                            <a id="reqdel">DELETE</a>
                        </p></li>
                    <%-- </c:if> --%>
                </ul>
            </aside>
            <!-- title_line end -->

            <div class="border_box" style="height: 340px;">
                <!-- border_box start -->

                <article class="grid_wrap">
                    <!-- grid_wrap start -->
                    <div id="req_grid_wrap"></div>
                </article>
                <!-- grid_wrap end -->

                <ul class="btns">
                    <li><a id="rightbtn"><img
                            src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif"
                            alt="right" /></a></li>
                    <%--     <li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a></li> --%>
                </ul>

            </div>
            <!-- border_box end -->

        </div>
        <!-- 50% end -->

    </div>
    <!-- divine_auto end -->

    <ul class="center_btns mt20">
        <%-- <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> --%>
        <li><p class="btn_blue2 big">
                <a id="save">Save</a>
            </p></li>
        <%-- </c:if>                 --%>
    </ul>

</section>

<!------------------------------------------------------------------------------
     Content END
------------------------------------------------------------------------------->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
