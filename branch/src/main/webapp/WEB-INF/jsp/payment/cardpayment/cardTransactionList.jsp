<!--=================================================================================================
* Task  : Billing & Collection
* File Name : cardTransactionList.jsp
* Description : Card Transaction Raw Data List
* Author : KR-OHK
* Date : 2019-09-30
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-09-30  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    // var ntceNo;
    //AUIGrid 생성 후 반환 ID

    var myGridID;

    // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [{
        dataField: "crcStateId",
        headerText: "<spring:message code='pay.head.crcNo'/>",
        editable: false,
        visible: true,
        width : 90
    },
   {
        dataField: "crcStateCrtDt",
        headerText: "<spring:message code='pay.head.uploadDate'/>",
        editable: false,
        visible: true,
        width : 120,
        dataType: "date",
        formatString: "dd/mm/yyyy"
    }
    ,{
        dataField: "crcStateRefNo",
        headerText: "<spring:message code='pay.head.statementNo'/>",
        editable: false,
        visible: true,
        width : 110
    }
    ,{
        dataField: "crcStateAccNm",
        headerText: "<spring:message code='pay.head.bank'/>",
        editable: false,
        visible: true,
        width : 170,
        //style: "aui-grid-user-custom-left"
    }
    ,{
        dataField: "crcTrnscMid",
        headerText: "<spring:message code='pay.head.mid'/>",
        editable: false,
        visible: true,
        width : 100
    }
    ,{
        dataField: "crcmode",
        headerText: "<spring:message code='pay.head.crcMode'/>",
        width : 110,
        editable: false,
        visible: true
    }
    ,{
        dataField: "tenure",
        headerText: "<spring:message code='pay.head.tenure'/>",
        width : 70,
        editable: false,
        visible: true
    }
    ,{
        dataField: "crcTrnscDt",
        headerText: "<spring:message code='pay.head.statementDate'/>",
        editable: false,
        visible: true,
        width : 90,
        dataType: "date",
        formatString: "dd/mm/yyyy"
    }
    ,{
        dataField: "crcTrnscNo",
        headerText: "<spring:message code='pay.head.crc.cardNo'/>",
        width : 150,
        editable: false,
        visible: true
    }
    ,{
        dataField: "crcTrnscAppv",
        headerText: "<spring:message code='pay.head.approvalCode'/>",
        width : 110,
        editable: false,
        visible: true,
        cellMerge : true
    }
    ,{
        dataField: "crcGrosAmt",
        headerText: "<spring:message code='pay.head.grossRM'/>",
        width : 100,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right",
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crcTrnscAppv"
    }
    ,{
        dataField: "crcTotBcAmt",
        headerText: "<spring:message code='pay.head.totalBc'/><spring:message code='service.grid.Rm'/>",
        width : 100,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right",
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crcTrnscAppv"
     }
    ,{
        dataField: "crcTotGstAmt",
        headerText: "<spring:message code='pay.head.gstRm'/>",
        width : 100,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right",
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crcTrnscAppv"
    }
    ,{
        dataField: "crcTotNetAmt",
        headerText: "<spring:message code='pay.head.netRm'/>",
        width : 100,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right",
        cellMerge : true,
        mergePolicy : "restrict",
        mergeRef : "crcTrnscAppv"
    }
    ,{
        dataField: "crcTrnscIsMtch",
        headerText: "<spring:message code='pay.head.satatus'/>",
        width : 100,
        editable: false,
        visible: true
    }
    ,{
        dataField: "crcStateMappingDt",
        headerText: "<spring:message code='pay.head.crcMappingDate'/>",
        editable: false,
        visible: true,
        width : 100,
        dataType: "date",
        formatString: "dd/mm/yyyy"
    }
    ,{
        dataField: "crcStateMappingId",
        headerText: "<spring:message code='pay.head.crcStateId'/>",
        width : 100,
        editable: false,
        visible: true
    }
    ,{
        dataField: "salesOrdNo",
        headerText: "<spring:message code='pay.head.order No'/>",
        width : 110,
        editable: false,
        visible: true
    }
    ,{
        dataField: "payItmAmt",
        headerText: "<spring:message code='pay.head.amount'/>",
        width : 110,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "orNo",
        headerText: "<spring:message code='pay.head.receiptNo'/>",
        width : 100,
        editable: false,
        visible: true
    }
    ,{
        dataField: "fTrnscId",
        headerText: "<spring:message code='pay.head.tranxId'/>",
        width : 90,
        editable: false,
        visible: true
    }];

    // 그리드 속성 설정
    var gridPros = {
        // 페이징 사용
        usePaging: false,
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount: 20,
        editable: false,
        showStateColumn: false,
        //displayTreeOpen: true,
        selectionMode: "multipleCells",
        headerHeight: 30,
        // 그룹핑 패널 사용
        useGroupingPanel: false,
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns: true,
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove: true,
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn: true,
        enableCellMerge : true
    };

    $(document).ready(function () {

        myGridID = GridCommon.createAUIGrid("grid_wrap_list", columnLayout,'',gridPros);

        //Credit Card Bank Account
        doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'bankAccount' , 'S', '');

        //Credit Card Bank Account
        doGetCombo('/common/selectCodeList.do', '36' , ''   , 'paymentMode' , 'S', '');

        //excel Download
        $('#excelDown').click(function() {
           GridCommon.exportTo("grid_wrap_list", 'xlsx', "Card Transaction List");
        });
    });

    // 리스트 조회.
    function fn_selectCardTransactionList() {

        if(FormUtil.checkReqValue($("#stateNo"), false) && FormUtil.checkReqValue($("#mid"), false)) {
            if(FormUtil.checkReqValue($("#stateDateFr"), false) && FormUtil.checkReqValue($("#stateDateTo"), false) &&
                    FormUtil.checkReqValue($("#transDateFr"), false) && FormUtil.checkReqValue($("#transDateTo"), false) ){
                Common.alert("<spring:message code='pay.alert.inputAtLeastOne'/>");
                return;
            }

            if((!FormUtil.checkReqValue($("#stateDateFr"), false) && FormUtil.checkReqValue($("#stateDateTo"), false)) ||
                    (FormUtil.checkReqValue($("#stateDateFr"), false) && !FormUtil.checkReqValue($("#stateDateTo"), false)) ){
                Common.alert("<spring:message code='pay.alert.inputStatementDate'/>");
                return;
            }

             if(FormUtil.diffDay($("#stateDateFr").val(), $("#stateDateTo").val()) > 31){
                 Common.alert("Upload Date is only within 31 days.");
                 return ;
             }

            if((!FormUtil.checkReqValue($("#transDateFr"), false) && FormUtil.checkReqValue($("#transDateTo"), false)) ||
                    (FormUtil.checkReqValue($("#transDateFr"), false, false) && !FormUtil.checkReqValue($("#transDateTo"), false)) ){
                Common.alert("<spring:message code='pay.alert.inputTransaction Date'/>");
                return;
            }

            if(FormUtil.diffDay($("#transDateFr").val(), $("#transDateTo").val()) > 31){
                Common.alert("Transaction Date is only within 31 days.");
                return ;
            }
        }

        Common.ajax("GET", "/payment/selectCardTransactionList", $("#searchForm").serialize(), function (result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_genCardKeyinRawPop(){
    	doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'rBankAccount' , 'S', '');
        $('#popup_wrap').show();
    }

    function fn_generateReport(){

        var d1Array = $("#keyinDateFr").val().split("/");
        var d1 = new Date(d1Array[2] + "-" + d1Array[1] + "-" + d1Array[0]);
        var d2Array = $("#keyinDateTo").val().split("/");
        var d2 = new Date(d2Array[2] + "-" + d2Array[1] + "-" + d2Array[0]);

        var whereSQL = '';

        if(dayDiffs(d1,d2) <= 30) {
            if($("#keyinDateFr").val() != "") {
                whereSQL += " AND SUB1.PAY_DATA >= TO_DATE('" + $("#keyinDateFr").val() + "', 'DD/MM/YYYY') ";
            } else {
                Common.alert("Please fill in key in start date.");
                return;
            }

            if($("#keyinDateTo").val() != "") {
                whereSQL += " AND SUB1.PAY_DATA < TO_DATE('" + $("#keyinDateTo").val() + "', 'DD/MM/YYYY') + 1";
            } else {
                Common.alert("Please fill in key in end date.");
                return;
            }

            if($("#rCrcNo").val() != "")
                whereSQL += " AND T3.CRC_STATE_ID = " + $("#rCrcNo").val() ;

            if($("#rCrcStateId").val() != "")
                whereSQL += " AND T2.CRC_TRNSC_ID = " + $("#rCrcStateId").val() ;

            if($("#rBankAccount").val() != "")
                whereSQL += " AND PD.PAY_ITM_BANK_ACC_ID = " + $("#rBankAccount").val() ;

            if($("#rStatus").val() != ""){
            	if($("#rStatus").val() == "0")
            	    whereSQL += " AND T1.CRC_STATE_MAPPING_STUS_ID != 4 " ;
            	if($("#rStatus").val() == "1")
            	    whereSQL += " AND T1.CRC_STATE_MAPPING_STUS_ID = 4 " ;
            	if($("#rStatus").val() == "2")
            	    whereSQL += " AND T1.REV_STUS_ID = 5 " ;
            }

            var date = new Date().getDate();
            if(date.toString().length == 1) date = "0" + date;

            $("#reportForm #reportDownFileName").val("Card_Keyin_Raw_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
            $("#reportForm #v_WhereSQL").val(whereSQL);
            $("#reportForm #viewType").val("EXCEL");
            $("#reportForm #reportFileName").val("/payment/PaymentCardKeyinRaw.rpt");

            var option = {
                    isProcedure : true
            };

            Common.report("reportForm", option);
        } else {
            Common.alert("Date range must be or equal to 30 days.");
        }
    }

    function dayDiffs(dayFr, dayTo){
        return Math.floor((dayTo.getTime() - dayFr.getTime())  /(1000 * 60 * 60 * 24));
    }

    function fn_close(){
        $("#reportForm")[0].reset();
        $("#popup_wrap").hide();
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Card Transaction Raw Data List</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectCardTransactionList();"><span  class="search"></span>Search</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm" action="#" method="post">
            <!-- table start -->
            <table class="type1">

                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='pay.head.uploadDate'/></th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="stateDateFr" name="stateDateFr" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"/></p>
                        <span>To</span>
                        <p><input id="stateDateTo" name="stateDateTo" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row"><spring:message code='pay.head.bankAccount'/></th>
                    <td>
                        <select id="bankAccount" name="bankAccount" class="w100p">
                        </select>
                    </td>
                    <th scope="row"><spring:message code='pay.head.statementNo'/></th>
                    <td>
                        <input id="stateNo" name="stateNo" type="text"  placeholder="" class="w100p" />
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='pay.head.transactionDate'/></th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="transDateFr" name="transDateFr" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                        <span>To</span>
                        <p><input id="transDateTo" name="transDateTo" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                        </div><!-- date_set end -->
                    </td>
                    <th scope="row"><spring:message code='pay.head.order No'/></th>
                    <td>
                        <input id="salesOrdNo" name="salesOrdNo" type="text"  placeholder="" class="w100p" />
                    </td>
                    <th scope="row"><spring:message code='pay.head.mid'/></th>
                    <td><input id="mid" name="mid" type="text"  placeholder="" class="w100p" /></td>
                </tr>

                <tr>

                    <th scope="row">CRC State ID</th>
                    <td >
                        <input id="crcStateId" name="crcStateId" type="text"  placeholder="" class="w100p" />
                    </td>
                    <th scope="row"></th>
                      <td colspan="3"></td>

                </tr>

                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <aside class="link_btns_wrap">
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
            <dt>Link</dt>
            <dd>
                <ul class="btns">
                    <li><p class="link_btn"><a href="javascript:fn_genCardKeyinRawPop();">Generate Card Key-in Raw Data</a></p></li>
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
            </dd>
        </dl>
    </aside>

    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code='sys.btn.excel.dw'/></a></p></li>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_wrap_list" style="width:100%; height:100%; margin:0 auto;" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->

<div id="popup_wrap" class="popup_wrap" style="display:none"><!-- popup_wrap start -->
<section id="content"><!-- content start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Card Key-in Report</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_close();" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form name="reportForm" id="reportForm" action="#" method="post">
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="v_WhereSQL" name="v_WhereSQL" value="" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th><spring:message code='pay.text.keyinDate'/></th>
    <td>
        <div class="date_set w100p">
            <p><input type="text" class="j_date" readonly id="keyinDateFr" name="keyinDateFr" placeholder="DD/MM/YYYY"/></p>
            <span>To</span>
            <p><input type="text" class="j_date" readonly id="keyinDateTo" name="keyinDateTo" placeholder="DD/MM/YYYY"/></p>
        </div>
    </td>
    <th scope="row"><spring:message code='pay.head.crcNo'/></th>
    <td><input type="text" class="w100p" id="rCrcNo" name="rCrcNo"></td>
</tr>
<tr>
    <th scope="row"><spring:message code='pay.head.crcState'/></th>
    <td><input type="text" class="w100p" id="rCrcStateId" name="rCrcStateId"></td>
    <th scope="row"><spring:message code='pay.head.bankAccount'/></th>
    <td><select class="w100p" id="rBankAccount" name="rBankAccount"></select></td>
</tr>
<tr>
    <th scope="row"><spring:message code='pay.head.Status'/></th>
    <td>
        <select class="w100p" id="rStatus">
            <option value="">Choose One</option>
            <option value="0">Unmatched</option>
            <option value="1">Matched</option>
            <option value="2">Reversed</option>
        </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_generateReport();">Generate Report</a></p></li>
</ul>

</form>
</section><!-- search_table end -->


</section><!-- content end -->
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->