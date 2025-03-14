<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
console.log("crcReconCRCState");

var mappingGridId;
var crcKeyInGridId;
var crcStateGridId;
var selectedGridValue;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false
};

var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 체크박스 표시 설정
        showRowCheckColumn : true,

        // 체크박스 대신 라디오버튼 출력함
        rowCheckToRadio : false,

        softRemoveRowMode:false,
        // 상태 칼럼 사용
        showStateColumn : false

};

var gridPros3 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 체크박스 표시 설정
        showRowCheckColumn : true,

        // 체크박스 대신 라디오버튼 출력함
        rowCheckToRadio : true,

        softRemoveRowMode:false,
        // 상태 칼럼 사용
        showStateColumn : false

};

$(document).ready(function(){

    doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'bankAcc' , 'S', '');

    mappingGridId = GridCommon.createAUIGrid("mapping_grid_wrap", mappingLayout,"",gridPros);
    crcKeyInGridId = GridCommon.createAUIGrid("crcKeyIn_grid_wrap", crcKeyInLayout,"",gridPros2);
    crcStateGridId = GridCommon.createAUIGrid("crcState_grid_wrap", crcStateLayout,"",gridPros3);

});

var mappingLayout = [
                       {
                           dataField : "crditCard",
                           headerText : "<spring:message code='pay.head.crc.credit'/>",
                           editable : false
                       }, {
                           dataField : "crcMcName",
                           headerText : "<spring:message code='pay.head.bankAccount'/>",
                           editable : false
                       }, {
                           dataField : "crcTrnscDt",
                           headerText : "<spring:message code='pay.head.transactionDate'/>",
                           editable : false
                       },{
                           dataField : "crcTrnscNo",
                           headerText : "<spring:message code='pay.head.crc.cardNo'/>",
                           editable : false
                       }, {
                           dataField : "cardModeName",
                           headerText : "<spring:message code='pay.head.cardMode'/>",
                           editable : false
                       }, {
                           dataField : "crcTrnscAppv",
                           headerText : "<spring:message code='pay.head.approvalNo'/>",
                           editable : false
                       }, {
                           dataField : "amount",
                           headerText : "<spring:message code='pay.head.amount'/>",
                           editable : false,
                           dataType:"numeric",
                           formatString:"#,##0.00"
                       },{
                           dataField : "groupSeq",
                           headerText : "<spring:message code='pay.head.groupSeq'/>",
                           visible : false
                       },{
                           dataField : "crcTrnscId",
                           headerText : "<spring:message code='pay.head.crcTrnscId'/>",
                           visible : false
                       },{
                           dataField : "crcStateAccId",
                           headerText : "<spring:message code='pay.head.crcStateAccId'/>",
                           visible : false
                       },{
                           dataField : "orNo",
                           headerText : "<spring:message code='pay.head.orNo'/>",
                           visible : false
                       },{
                           dataField : "ordNo",
                           headerText : "<spring:message code='pay.head.ordNo'/>",
                           visible : false
                       },{
                           dataField : "crcTrnscMid",
                           headerText : "<spring:message code='pay.head.crcTrnscMid'/>",
                           visible : false
                       },{
                           dataField : "crcStateAccCode",
                           headerText : "",
                           visible : false
                       }];

var crcKeyInLayout = [
                       {
                           dataField : "salesOrdNo",
                           headerText : "<spring:message code='pay.head.orderNO'/>",
                           editable : false
                       }, {
                           dataField : "crcMcName",
                           headerText : "<spring:message code='pay.head.mcBank'/>",
                           editable : false
                       }, {
                           dataField : "payItmRefDt",
                           headerText : "<spring:message code='pay.head.trDate'/>",
                           editable : false,
                           dataType : "date",
                           formatString : "dd/mm/yyyy"
                       }, {
                           dataField : "payItmCcNo",
                           headerText : "<spring:message code='pay.head.crc.cardNo'/>",
                           editable : false,
                       }, {
                           dataField : "cardModeName",
                           headerText : "<spring:message code='pay.head.Card Mode'/>",
                           editable : false,
                       }, {
                           dataField : "payItmAppvNo",
                           headerText : "<spring:message code='pay.head.approvalNo'/>",
                           editable : false
                       }, {
                           dataField : "amount",
                           headerText : "<spring:message code='pay.head.Amount'/>",
                           editable : false,
                           dataType:"numeric",
                           formatString:"#,##0.00"
                       },{
                           dataField : "groupSeq",
                           headerText : "<spring:message code='pay.head.groupSeq'/>",
                           visible : false
                       },{
                           dataField : "rnum",
                           headerText : "<spring:message code='pay.head.rnum'/>",
                           visible : false
                       },{
                           dataField : "orNo",
                           headerText : "<spring:message code='pay.head.orNo'/>",
                           visible : false
                       },{
                           dataField : "ordNo",
                           headerText : "<spring:message code='pay.head.ordNo'/>",
                           visible : false
                       }];

var crcStateLayout = [
                      {
                          dataField : "bankAccName",
                          headerText : "<spring:message code='pay.head.bankAccount'/>",
                          editable : false
                      }, {
                          dataField : "crcTrnscDt",
                          headerText : "<spring:message code='pay.head.trDate'/>",
                          editable : false
                      }, {
                          dataField : "crcTrnscNo",
                          headerText : "<spring:message code='pay.head.crc.cardNo'/>",
                          editable : false
                      }, {
                          dataField : "crcTrnscAppv",
                          headerText : "<spring:message code='pay.head.approvalNo'/>",
                          editable : false
                      }, {
                          dataField : "grosAmt",
                          headerText : "<spring:message code='pay.head.grossAmount'/>",
                          editable : false,
                          dataType:"numeric",
                          formatString:"#,##0.00"
                      }, {
                          dataField : "crcTrnscId",
                          headerText : "<spring:message code='pay.head.crcTrnscId'/>",
                          visible : false
                      }, {
                          dataField : "crcStateAccId",
                          headerText : "<spring:message code='pay.head.crcStateAccId'/>",
                          visible : false
                      }, {
                          dataField : "crcTrnscMid",
                          headerText : "<spring:message code='pay.head.crcTrnscMid'/>",
                          visible : false
                      },{
                          dataField : "crcStateAccCode",
                          headerText : "",
                          visible : false
                      },{
                          dataField : "crditCard",
                          headerText : "",
                          visible : false
                      }];


    function fn_getCrcReconStateList(ordNo, ordId){

        if($("#bankAcc").val() == ''){
            Common.alert("Select Bank Account.");
            return;
        }

        if($("#transDateFr").val() != '' && $("#transDateTo").val() != ''){
            var dtArr;

            var fdate = $("#transDateFr").val();
            dtArr = fdate.split("/");
            fdate = new Date(Number(dtArr[2]), Number(dtArr[1]) - 1, Number(dtArr[0]));

            var tdate = $("#transDateTo").val();
            dtArr = tdate.split("/");
            tdate = new Date(Number(dtArr[2]), Number(dtArr[1]) - 1, Number(dtArr[0]));

            console.log("frdate :: " + fdate );
            console.log("todate :: " + tdate );
            console.log("todate <= frdate :: " + tdate <= fdate);

            var months = (tdate.getFullYear() - fdate.getFullYear()) * 12;
            months -= fdate.getMonth();
            months += tdate.getMonth();

            if(($("#stmtDateFr").val() != "" && $("#stmtDateTo").val() == "") || ($("#stmtDateFr").val() == "" && $("#stmtDateTo").val() != "")) {
                Common.alert("Statement Dates incomplete.");
                return;
            } else if($("#stmtDateFr").val() != "" && $("#stmtDateTo").val() != "") {
                var sfdate = $("#stmtDateFr").val();
                dtArr = sfdate.split("/");
                sfdate = new Date(Number(dtArr[2]), Number(dtArr[1]) - 1, Number(dtArr[0]));

                var stdate = $("#stmtDateTo").val();
                dtArr = stdate.split("/");
                stdate = new Date(Number(dtArr[2]), Number(dtArr[1]) - 1, Number(dtArr[0]));

                if(sfdate > stdate) {
                    Common.alert("Statement From Date cannot be later than Statement To Date.");
                    return;
                }
            }

            if(fdate <= tdate) {
                //if(months <= 6 && months >= 0) {
                    console.log("flg");
                    Common.ajax("GET","/payment/selectCrcReconCRCStateInfo.do", $("#searchForm").serialize(), function(result){
                        console.log(result);
                        AUIGrid.setGridData(mappingGridId, result.mappingList);
                        AUIGrid.setGridData(crcKeyInGridId, result.keyInList);
                        AUIGrid.setGridData(crcStateGridId, result.stateList);
                    });
                //} else {
                    //Common.alert("Only maximum 6 months of transaction date allowed.");
                //}
            } else{
                Common.alert("From date must not be greater than to date.");
            }

        }else{
            Common.alert("Select Transaction Date.");
        }
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
    }

    function fn_mappingProc() {

        var crcKeyInChkItem = AUIGrid.getCheckedRowItems(crcKeyInGridId);
        var crcStateChkItem = AUIGrid.getCheckedRowItems(crcStateGridId);
        var crcKeyInVal;
        var keyInRowItem;
        var stateRowItem;
        var item = new Object();

        if(crcKeyInChkItem.length < 1 ){
            Common.alert("<spring:message code='pay.alert.crcKeyInData'/>");
            return;
        }

        if(crcStateChkItem.length < 1){
            Common.alert("<spring:message code='pay.alert.crcStateData'/>");
            return;
        }

        for(i = 0 ; i < crcKeyInChkItem.length ; i++){
            keyInRowItem = crcKeyInChkItem[i];
            stateRowItem = crcStateChkItem[0];

            crcKeyInVal = keyInRowItem.item.groupSeq;
            item.cardModeName = keyInRowItem.item.cardModeName;
            item.crcMcName = stateRowItem.item.bankAccName;
            item.crcTrnscDt = stateRowItem.item.crcTrnscDt;
            item.crcTrnscNo = stateRowItem.item.crcTrnscNo; // crcNo no check?
            item.crcTrnscAppv = stateRowItem.item.crcTrnscAppv;
            item.amount = stateRowItem.item.grosAmt;
            item.groupSeq = crcKeyInVal;//hidden field
            item.orNo = keyInRowItem.item.orNo;//hidden field
            item.ordNo = keyInRowItem.item.ordNo;//hidden field
            item.crcTrnscId = stateRowItem.item.crcTrnscId;//hidden field
            item.crcStateAccId = stateRowItem.item.crcStateAccId;//hidden field
            item.crcTrnscMid = stateRowItem.item.crcTrnscMid;//hidden field
            item.crcStateAccCode = stateRowItem.item.accCode;//hidden field
            item.crditCard = stateRowItem.item.crditCard;//hidden field

            console.log(item);
            AUIGrid.addRow(mappingGridId, item, "last");
        }

        AUIGrid.removeCheckedRows(crcKeyInGridId);
        AUIGrid.removeCheckedRows(crcStateGridId);
    }

    function fn_mappingListKnockOff() {

        var gridList = AUIGrid.getGridData(mappingGridId);
        var data = {};
        if(gridList.length > 0) {
            data.all = gridList;

            Common.confirm("<spring:message code='pay.alert.knockOffCrc'/>",function (){

                Common.ajax("POST","/payment/updCrcReconState.do", data , function(result){
                    console.log(result);

                    AUIGrid.clearGridData(mappingGridId);
                    Common.alert(result.message);
                });

            });

        }else{
            Common.alert("<spring:message code='pay.alert.noMapping'/>");
        }
    }

    function fn_incomeProc() {
        var crcStateChkItem = AUIGrid.getCheckedRowItems(crcStateGridId);
        var stateRowItem;

        if(crcStateChkItem.length > 0){

            stateRowItem = crcStateChkItem[0];

            $("#other_inc_pop").show();
            $("#popCrcTrnscId").val(stateRowItem.item.crcTrnscId);
            $("#crcStmtAmt").val(AUIGrid.formatNumber(stateRowItem.item.grosAmt, "#,##0.00"));

        }else{
            Common.alert("<spring:message code='pay.alert.crcStateData'/>");
        }
    }

    function fn_saveIncomeProc() {
        Common.confirm("Do you want to confirm the seleced item as income?",function (){

            Common.ajax("GET","/payment/updIncomeCrcStatement", {"crcTrnscId" : $("#popCrcTrnscId").val(), "grosAmt" : $("#crcStmtAmt").val(), "action" : $("#action").val()}, function(result){

                var action;
                if($("#action").val() == "INC") {
                    action = "Income";
                } else {
                    action = "Contra";
                }

                var message = "Success " + action +" Process";
                Common.alert(message, function(){
                    fn_getCrcReconStateList();
                });
            });
        });
    }

</script>
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Payment Key-In & Credit Card Statement</h2>
        <ul class="right_btns">
         <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_getCrcReconStateList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
         </c:if>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form action="#" method="post" id="searchForm">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>Transaction Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="transDateFr" name="transDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="transDateTo" name="transDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th>Bank Account</th>
                        <td>
                            <select id="bankAcc" name="bankAcc" class="w100p" ></select>
                        </td>
                    </tr>
                    <tr>
                        <th>Statement Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="stmtDateFr" name="stmtDateFr" title="Statement Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="stmtDateTo" name="stmtDateTo" title="Statement End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th></th>
                        <td></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
            <article id="mapping_grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->


    <div class="divine_auto"><!-- divine_auto start -->
        <div style="width:50%;">
            <aside class="title_line"><!-- title_line start -->
                <h3>Credit Card Key-in List</h3>
            </aside><!-- title_line end -->
            <article id="crcKeyIn_grid_wrap" class="grid_wrap"></article>
        </div><!-- border_box end -->
        <div style="width:50%;">
            <aside class="title_line"><!-- title_line start -->
                <h3>Credit Card Statement</h3>
            </aside><!-- title_line end -->
            <article id="crcState_grid_wrap" class="grid_wrap"></article>
        </div>
    </div>


    <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="btn_blue2"><a href="javascript:fn_incomeProc();" id="btnIncome">Income/Contra</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="btn_blue2"><a href="javascript:fn_mappingProc();" id="btnMapping"><spring:message code='pay.btn.mapping'/></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="btn_blue2"><a href="javascript:fn_mappingListKnockOff();" id="btnKnockOff"><spring:message code='pay.btn.knockOff'/></a></p></li>
    </c:if>
    </ul>
</section><!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (NEW UPLOADED BATCH ERROR)
-------------------------------------------------------------------------------------->
<div class="popup_wrap size_mid" id="other_inc_pop" style="display: none;">
    <header class="pop_header"><!-- pop_header start -->
        <h1>Contra/Other Income</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="newWebInvoice.btn.close" /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <input type="hidden" id="popCrcTrnscId" name="crcTrnscId">

        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:200px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th>Card Statement Amount</th>
                    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="crcStmtAmt" name="crcStmtAmt"/></td>
                </tr>
                <tr>
                    <th>Action</th>
                    <td colspan="3">
                        <select class="w100p" id="action" name="action">
                            <option value="" selected>Choose One</option>
                            <option value="CTR">Contra</option>
                            <option value="INC">Other Income</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>Remark</th>
                    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="expDesc" name="expDesc" /></td>
                </tr>
            </tbody>
        </table>

        <ul class="center_btns" id="newBulkBtns">
            <li><p class="btn_blue2"><a href="javascript:fn_saveIncomeProc();" id="proceedBtn">Save</a></p></li>
        </ul>
    </section>
</div>