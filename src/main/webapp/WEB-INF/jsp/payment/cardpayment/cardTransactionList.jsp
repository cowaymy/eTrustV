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

