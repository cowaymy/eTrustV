<style type="text/css">

/* gride 동적 버튼 */
.edit-column {
    visibility:hidden;
}
</style>
<script type="text/javaScript" language="javascript">

    //AUIGrid ���� �� ��ȯ ID
        var msgGridID;
        var orderGridID;

    $(document).ready(function(){
        //AUIGrid �׸��带 �����մϴ�.
        createMsgGrid();
        createOrderGrid();

        fn_getMsgLogAjax();
        fn_getOrderAjax();

    });

    function createMsgGrid(){
        //govAgMsgAttachFileName
        var msgColumnLayout = [

                                   {dataField : "userName" , headerText : '<spring:message code="sal.text.creator" />' , width : "10%"},
                                   {dataField : "govAgMsgCrtDt" , headerText : '<spring:message code="sal.text.created" />' , width : "10%"},
                                   {dataField : "name" , headerText : '<spring:message code="sal.title.status" />' , width : "10%"},
                                   {dataField : "govAgPrgrsName" , headerText : '<spring:message code="sal.title.text.prgss" />' , width : "10%"},
                                   {dataField : "govAgRoleDesc" , headerText : '<spring:message code="sal.text.dept" />' , width : "10%"},
                                   {dataField : "govAgMsg" , headerText : '<spring:message code="sal.title.text.msg" />' , width : "30%"},
                                   {dataField : "govAgMsgHasAttach" , headerText : '<spring:message code="sal.title.text.attatch" />' , width : "10%"},
                                   {dataField : "atchFileGrpId" , visible : false},
                                   {dataField : "atchFileId",  headerText : '<spring:message code="sal.title.text.download" />', width : '10%', styleFunction : cellStyleFunction,
                                         renderer : {
                                           type : "ButtonRenderer",
                                           labelText : "Download",
                                           onclick : function(rowIndex, columnIndex, value, item) {

                                               Common.showLoader();
                                                var fileId = value;
                                              $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                                                   httpMethod: "POST",
                                                   contentType: "application/json;charset=UTF-8",
                                                   data: {
                                                       fileId: fileId
                                                   },
                                                   failCallback: function (responseHtml, url, error) {
                                                       Common.alert($(responseHtml).find("#errorMessage").text());
                                                   }
                                               }).done(function () {
                                                       Common.removeLoader();
                                                       console.log('File download a success!');
                                               }).fail(function () {
                                                       Common.alert('<spring:message code="sal.alert.msg.fileMissing" />');
                                                       Common.removeLoader();
                                               });



                                           }
                                         }
                                     },
                                     {dataField : "smsContent" , headerText : 'SMS' , width : "30%"}
                                     ];

         //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : false,
                displayTreeOpen     : false,
       //         selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        msgGridID = GridCommon.createAUIGrid("msgLog_grid_wrap", msgColumnLayout,'', gridPros);

    }

    function createOrderGrid(){

        var orderColumnLayout = [
                               {dataField : "salesOrdId",   visible : false},
                               {dataField : "salesOrdNo" , headerText : '<spring:message code="sal.text.ordNo" />' , width : "20%"},
                               {dataField : "name" , headerText : '<spring:message code="sal.title.text.customer" />' , width : "40%"},
                               {dataField : "ordStatus" , headerText : '<spring:message code="sal.text.orderStatus" />' , width : "20%"},
                               {dataField : "stkDesc" , headerText : '<spring:message code="sal.title.text.productModel" />' , width : "20%"},
                               {dataField : "ordMthRental" , headerText : '<spring:message code="sal.title.text.finalRentalFees" />' , width : "20%"}
        ];

         //그리드 속성 설정
        var gridPros = {

                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
                editable            : false,
                fixedColumnCount    : 1,
                showStateColumn     : true,
                displayTreeOpen     : false,
    //            selectionMode       : "singleRow",  //"multipleCells",
                headerHeight        : 30,
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true
            };

        orderGridID = GridCommon.createAUIGrid("order_grid_wrap", orderColumnLayout,'', gridPros);
    }

    // ����Ʈ ��ȸ.
    function fn_getMsgLogAjax(){
    	var msgParam = {govAgId : $("#_govAgId").val()};
         Common.ajax("GET", "/sales/ccp/selectRentalMessageLogAjax",  msgParam, function(result) {
            AUIGrid.setGridData(msgGridID, result);

         });
    }

    function fn_getOrderAjax(){
    	var orderParam = {govAgId : $("#_govAgId").val()};
         Common.ajax("GET", "/sales/ccp/selectRentalContactOrdersAjax",  orderParam, function(result) {
            AUIGrid.setGridData(orderGridID, result);

         });
    }

  //addcolum button hidden
    function cellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField){

        if(item.govAgMsgHasAttach == 'Yes'){
            return '';
        }else{
            return "edit-column";
        }
    }
</script>

<article class="tap_area"><!-- tap_area start -->

<form  id="_searchForm">
    <input type="hidden" name="govAgId" value="${orderDetail.renAgrInfo.govAgId}" id="_govAgId">
</form>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agrNo" /></th>
    <td><span>${orderDetail.renAgrInfo.govAgBatchNo}</span></td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td><span>${orderDetail.renAgrInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agreeType" /></th>
    <td><span>${orderDetail.renAgrInfo.codeName}</span></td>
    <th scope="row">Date Created</th>
    <td><span>${orderDetail.renAgrInfo.govAgCrtDt}</span></td>
</tr>
<tr>
    <th scope="row">No. of copies</th>
    <td><span>${orderDetail.renAgrInfo.govAgQty}</span></td>
    <th scope="row"><spring:message code="sal.title.text.agrStatus" /></th>
    <td><span>${orderDetail.renAgrInfo.name1}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.prgss" /></th>
    <td><span>${orderDetail.renAgrInfo.govAgPrgrsName}</span></td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td><span>${orderDetail.renAgrInfo.userName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.renAgrStart" /></th>
    <td><span>${orderDetail.renAgrInfo.govAgStartDt}</span></td>
    <th scope="row"><spring:message code="sal.title.text.renAgrExpiry" /></th>
    <td><span>${orderDetail.renAgrInfo.govAgEndDt}</span></td>
</tr>
<tr>
    <th scope="row">Coway's Template</th>
    <td><span>${orderDetail.renAgrInfo.govAgTemplate}</span></td>
    <th scope="row"><spring:message code="sal.title.text.cntcAgrPeriod" /></th>
    <td><span>${orderDetail.renAgrInfo.govAgPeriod}</span></td>
</tr>
<tr>
    <th scope="row">Received Customer's Draft /Draft sent to customer</th>
    <td><span>${orderDetail.renAgrInfo.govAgDraftDt}</span></td>
    <th scope="row">1st Review</th>
    <td><span>${orderDetail.renAgrInfo.govAgFirstRevDt}</span></td>
</tr>
<tr>
    <th scope="row">Received 1st Feedback from Customer</th>
    <td>
    <span>${orderDetail.renAgrInfo.isGovAgFirstFeed}</span>
    <span>${orderDetail.renAgrInfo.govAgFirstFeedDt}</span>
    </td>
    <th scope="row">2nd Review</th>
    <td>
    <span>${orderDetail.renAgrInfo.isGovAgSecRev}</span>
    <span>${orderDetail.renAgrInfo.govAgSecRevDt}</span>
    </td>
</tr>
<tr>
    <th scope="row">Received 2nd Feedback from Customer</th>
    <td>
    <span>${orderDetail.renAgrInfo.isGovAgSecFeed}</span>
    <span>${orderDetail.renAgrInfo.govAgSecFeedDt}</span>
    </td>
    <th scope="row">3rd Review</th>
    <td>
    <span>${orderDetail.renAgrInfo.isGovAgThirdRev}</span>
    <span>${orderDetail.renAgrInfo.govAgThirdRevDt}</span>
    </td>
</tr>
<tr>
    <th scope="row">Agreement Finalised</th>
    <td><span>${orderDetail.renAgrInfo.govAgFinalDt}</span></td>
</tr>
<tr>
    <th scope="row">RFD Required</th>
    <td>
    <span>${orderDetail.renAgrInfo.isGovAgRfd}</span>
    <span>${orderDetail.renAgrInfo.govAgRfdDt}</span>
    </td>
    <th scope="row">RFD/Business Unit Approval Received</th>
    <td>
    <span>${orderDetail.renAgrInfo.isGovAgOthDept}</span>
    <span>${orderDetail.renAgrInfo.govAgOthDeptDt}</span>
    </td>
</tr>
<tr>
    <th scope="row">Agreement Executed</th>
    <td><span>${orderDetail.renAgrInfo.govAgExeDt}</span></td>
    <th scope="row">Sent for stamping</th>
    <td><span>${orderDetail.renAgrInfo.govAgSentStampDt}</span></td>
</tr>
<tr>
    <th scope="row">Received Stamp Certificate</th>
    <td><span>${orderDetail.renAgrInfo.govAgRecStampDt}</span></td>
    <th scope="row">Courier Out</th>
    <td><span>${orderDetail.renAgrInfo.govAgCourierDt}</span></td>
</tr>
<tr>
    <th scope="row">Contract Contains Early Termination Clause</th>
    <td><span>${orderDetail.renAgrInfo.erlTerNonCrisisChk}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<!-- message log -->
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.msgLog" /></h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="msgLog_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.newOrder" /></h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="order_grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->



</article><!-- tap_area end -->