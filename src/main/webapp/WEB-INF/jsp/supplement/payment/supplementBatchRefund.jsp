<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.aui-grid-user-custom-left {
    text-align:left;
}

.aui-grid-user-custom-right {
    text-align:right;
}
</style>
<script type="text/javascript">
var batchId = 0;
var bRefundColumnLayout = [
    {
        dataField : "batchId",
        headerText : "<spring:message code='supplement.head.batchId'/>",
        dataType : "numeric"
    }, {
        dataField : "codeName",
        headerText : "<spring:message code='supplement.head.payType'/>"
    }, {
        dataField : "name",
        headerText : "<spring:message code='supplement.head.batchStatus'/>"
    }, {
        dataField : "name1",
        headerText : "<spring:message code='supplement.head.confirmStatus'/>"
    }, {
        dataField : "updDt",
        headerText : "<spring:message code='supplement.head.uploadDate'/>",
        dataType : "date",
        formatString : "dd/mm/yyyy"
    }, {
        dataField : "username1",
        headerText : "<spring:message code='supplement.head.uploadBy'/>"
    }, {
        dataField : "cnfmDt",
        headerText : "<spring:message code='supplement.head.confirmDate'/>"
    }, {
        dataField : "c1",
        headerText : "<spring:message code='supplement.head.confirmBy'/>"
    }, {
        dataField : "cnvrDt",
        headerText : "<spring:message code='supplement.head.convertDate'/>"
    }, {
        dataField : "c2",
        headerText : "<spring:message code='supplement.head.convertBy'/>"
    }
];

var bRefundGridPros = {
    usePaging : true,
    pageRowCount : 20,
    selectionMode : "multipleCells",
    showStateColumn : true
};

var bRefundGridID;

$(document).ready(function () {
	bRefundGridID = AUIGrid.create("#bRefund_grid_wrap", bRefundColumnLayout, bRefundGridPros);

	$("#viewPop_btn").click(fn_bRefundViewPop);
	$("#uploadPop_btn").click(fn_bRefundUploadPop);
	$("#confirm_btn").click(fn_bRefundConfirmPop);

    $("#payMode").multipleSelect("setSelects", [108]);
    $("#cnfmStus").multipleSelect("setSelects", [44]);
    $("#batchStus").multipleSelect("setSelects", [1]);

	fn_setToDay();

	AUIGrid.bind(bRefundGridID, "cellClick", function(event) {
        batchId = event.item.batchId;
    });

	$('#excelDown').click(function() {
          GridCommon.exportTo("bRefund_grid_wrap", "xlsx", "Supplement - Batch Refund List");
    });
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

function fn_bRefundViewPop() {
	if(batchId > 0) {
		Common.popupDiv("/supplement/payment/batchRefundViewPop.do", {batchId:batchId}, null, true, "bRefundViewPop");
	} else {
		Common.alert('<spring:message code="supplement.alert.noBatch"/>');
	}
}

function fn_selectBatchRefundList() {
	Common.ajax("GET", "/supplement/payment/selectBatchRefundList.do?_cacheId=" + Math.random(), $("#form_bRefund").serialize(), function(result) {
        AUIGrid.setGridData(bRefundGridID, result);
    });
}

function fn_formClear() {
	$("#form_bRefund").each(function() {
        this.reset();
    });
}

function fn_bRefundUploadPop() {
	Common.popupDiv("/supplement/payment/batchRefundUploadPop.do", null, null, true, "bRefundUploadPop");
}

function fn_bRefundConfirmPop() {
	if(batchId > 0) {
		Common.popupDiv("/supplement/payment/batchRefundConfirmPop.do", {batchId:batchId}, null, true, "bRefundConfirmPop");
    } else {
        Common.alert('<spring:message code="supplement.alert.noBatch"/>');
    }
}
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2><spring:message code='supplement.title.supplementBatchRefund'/></h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" id="confirm_btn"><spring:message code='supplement.btn.batRefundConfirm'/></a></p></li>
            <li><p class="btn_blue"><a href="#" id="uploadPop_btn"><spring:message code='supplement.btn.batRefundUpload'/></a></p></li>
            <li><p class="btn_blue"><a href="#" id="viewPop_btn"><spring:message code='supplement.btn.batRefundView'/></a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectBatchRefundList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_formClear()"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
    <form action="#" id="form_bRefund">
        <table class="type1"><!-- table start -->
            <caption><spring:message code='pay.text.table'/></caption>
            <colgroup>
                <col style="width:180px" />
                <col style="width:*" />
                <col style="width:180px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><spring:message code='supplement.head.batchId'/></th>
                    <td><input type="text" title="Batch ID (Number Only)" placeholder="Batch ID (Number Only)" class="w100p" id="batchId" name="batchId"/></td>
                    <th scope="row"><spring:message code='supplement.head.paymode'/></th>
                    <td>
                       <select id="payMode" name="payMode" class="multy_select w100p" multiple="multiple">
                            <c:forEach var="list" items="${paymentMode}" varStatus="status">
                              <option value="${list.codeId}">${list.codeName}</option>
                            </c:forEach>
                       </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='supplement.head.createDate'/></th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                            <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
                            <span><spring:message code='supplement.text.to'/></span>
                            <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row"><spring:message code='supplement.head.confirmStatus'/></th>
                    <td>
                      <select id="cnfmStus" name="cnfmStus" class="multy_select w100p" multiple="multiple">
                          <c:forEach var="list" items="${batchConfirmationStatus}" varStatus="status">
                              <option value="${list.codeId}">${list.codeName}</option>
                          </c:forEach>
                       </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='supplement.head.batchStatus'/></th>
                    <td>
                        <select id="batchStus" name="batchStus" class="multy_select w100p" multiple="multiple">
                              <c:forEach var="list" items="${batchStatus}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName}</option>
                              </c:forEach>
                         </select>
                    </td>
                    <th scope="row"><spring:message code='supplement.head.creator'/></th>
                    <td>
                        <input type="text" title="Creator (Username)" placeholder="Creator (Username)" class="w100p" id="crdUserName" name="crtUserIdName"/>
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
          <li>
            <p class="btn_grid">
              <a href="#" id="excelDown"><spring:message code='pay.btn.generate' /></a>
            </p>
          </li>
        </c:if>
    </ul>
    <section class="search_result"><!-- search_result start -->
       <article class="grid_wrap" id="bRefund_grid_wrap"></article>
    </section><!-- search_result end -->
</section><!-- content end -->
