
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var myGridID;
    var basicAuth = false;

    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

      //AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#reqId").val(event.item.reqId);
            $("#callEntryId").val(event.item.callEntryId);
            $("#salesOrdId").val(event.item.ordId);
            $("#typeId").val(event.item.typeId);
            $("#docId").val(event.item.docId);
            $("#refId").val(event.item.refId);
            $("#paramReqStageId").val(event.item.paramReqStageId);

            Common.popupDiv("/sales/order/cancelReqInfoPop.do", $("#detailForm").serializeJSON());

            //Basic Auth (update Btn)
//            if('${PAGE_AUTH.funcChange}' == 'Y'){
//                basicAuth = true;
//            }
        });

        // 셀 클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellClick", function(event) {
            $("#reqId").val(event.item.reqId);
            $("#callEntryId").val(event.item.callEntryId);
            $("#salesOrdId").val(event.item.ordId);
            $("#typeId").val(event.item.typeId);
            $("#docId").val(event.item.docId);
            $("#refId").val(event.item.refId);
            $("#paramCallStusId").val(event.item.callStusId);
            $("#paramCallStusCode").val(event.item.callStusCode);
            $("#paramReqNo").val(event.item.reqNo);
            $("#paramReqStusId").val(event.item.reqStusId);
            $("#paramReqStusCode").val(event.item.reqStusCode);
            $("#paramReqStusName").val(event.item.reqStusName);
            $("#paramReqStageId").val(event.item.reqStageId);
            $("#paramRsoStusId").val(event.item.rsoStus);
            $("#paramSalesOrdNo").val(event.item.ordNo);

            gridValue =  AUIGrid.getCellValue(myGridID, event.rowIndex, $("#detailForm").serializeJSON());
        });

    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "reqNo",
                headerText : "<spring:message code='sal.title.text.reqNo' />",
                width : 140,
                editable : false
            }, {
                dataField : "reqStusCode",
                headerText : "<spring:message code='sal.title.status' />",
                width : 100,
                editable : false
            }, {
                dataField : "ordNo",
                headerText : "<spring:message code='sal.title.ordNo' />.",
                width : 120,
                editable : false
            }, {
                dataField : "appTypeName",
                headerText : "<spring:message code='sal.title.text.appType' />",
                width : 120,
                editable : false
            }, {
                dataField : "custName",
                headerText : "<spring:message code='sal.title.text.customer' />",
                editable : false
            }, {
                dataField : "custIc",
                headerText : "<spring:message code='sal.title.text.nricCompNo' />",
                width : 170,
                editable : false
            }, {
                dataField : "reqStage",
                headerText : "<spring:message code='sal.title.text.requestStage' />",
                editable : false
            }, {
                dataField : "callStusName",
                headerText : "<spring:message code='sal.title.text.callStatus' />",
                editable : false
            }, {
                dataField : "callRecallDt",
                headerText : "<spring:message code='sal.title.text.reCallDate' />",
                dataType : "date",
                formatString : "dd-mm-yyyy" ,
                editable : false
            },{
                dataField : 'rsoStus' ,
                headerText : 'RSO Status' ,
                  width : 100,
                editable : false

            },{
                dataField : "callEntryId",
                visible : false
            },{
                dataField : "docId",
                visible : false
            },{
                dataField : "typeId",
                visible : false
            },{
                dataField : "refId",
                visible : false
            },{
                dataField : "reqStusId",
                visible : false
            },{
                dataField : "callStusId",
                visible : false
            },{
                dataField : "callStusCode",
                visible : false
            },{
                dataField : "callStusName",
                visible : false
            },{
                dataField : "reqStageId",
                visible : false
            }];

     // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : true,

            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,

            editable : true,

            fixedColumnCount : 1,

            showStateColumn : false,

            displayTreeOpen : true,

            selectionMode : "multipleCells",

            headerHeight : 30,

            // 그룹핑 패널 사용
            useGroupingPanel : false,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,

            groupingMessage : "Here groupping"
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '10', '','cmbAppTypeId', 'M' , 'f_multiCombo');            // Application Type Combo Box

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbAppTypeId').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
            $('#cmbAppTypeId').multipleSelect("checkAll");
        });
    }

    // 리스트 조회.
    function fn_orderCancelListAjax() {
        Common.ajax("GET", "/sales/order/orderCancelJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_newLogResult() {
        if(detailForm.reqId.value == ""){
            Common.alert("No cancellation request selected.");
            return false;
        }

        if(detailForm.paramCallStusCode.value == 'CC'){
            Common.alert("not available to use this function when Call Log Status in ‘CC’");
            return false;
       }
        //else{test--------
        //  if(detailForm.paramCallStusId.value != '1' && detailForm.paramCallStusId.value != '19'){
        //      Common.alert("Cancellation request [" +detailForm.paramReqNo.value+ "] is under call status ["
        //                        +detailForm.paramCallStusCode.value+ "] <br>" +"Key in new call result is disallowed.");
        //      return false;
        //  }else{
        //      if(detailForm.paramReqStusId.value != '1' && detailForm.paramReqStusId.value != '19'){
        //            Common.alert("Cancellation request [" +detailForm.paramReqNo.value+ "] is under call status ["
        //                            +detailForm.paramReqStusCode.value+ "] <br>" +"Key in new call result is disallowed.");
        //            return false;
        //      }
        //  }
            Common.popupDiv("/sales/order/cancelNewLogResultPop.do", $("#detailForm").serializeJSON(), null , true, '_newDiv');
        //}

    }


    function fn_newRsoResult(){

        if(detailForm.reqId.value == ""){
            Common.alert("No cancellation request selected.");
            return false;
        }
        if(detailForm.paramRsoStusId.value != 'ACT'){
             Common.alert("Only available to use this function  in case of Return Service Order Status in ‘ACT’");
             return false;
        }

        var salesOrdId1 = detailForm.salesOrdId.value;
        var salesOrdNo1 = detailForm.paramSalesOrdNo.value;

        Common.popupDiv("/sales/order/addProductReturnPopup.do?isPop=true&salesOrderId="+salesOrdId1 + "&salesOrderNO=" + salesOrdNo1 , $("#detailForm").serializeJSON(), null, "false", "addInstallationPopupId");

    }

        $.fn.clearForm = function() {
            return this.each(function() {
                var type = this.type, tag = this.tagName.toLowerCase();
                if (tag === 'form'){
                    return $(':input',this).clearForm();
                }
                if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                    this.value = '';
                    this.text='';
                }else if (type === 'checkbox' || type === 'radio'){
                    this.checked = false;
                    this.text='';
                }else if (tag === 'select'){
                    this.selectedIndex = -1;
                    this.text='';
                }
            });
        };

    function fn_ctAssignment(){
        if(detailForm.reqId.value == ""){
            Common.alert("<spring:message code='sal.alert.msg.noCancelRequestSelected' />.");
            return false;
        }else{
            if(detailForm.paramReqStageId.value == '24'){
                Common.alert("[" +detailForm.paramReqNo.value+ "<spring:message code='sal.alert.msg.onlyRequestAfterInstallIsAllow' />.");
                return false;
            }
            if(detailForm.paramCallStusId.value == '1' || detailForm.paramCallStusId.value == '19'){
                Common.alert("[" +detailForm.paramReqNo.value+ "] is under status ["+detailForm.paramReqStusName.value+"] </br> <spring:message code='sal.alert.msg.reassignCtIsDisallowed' />.");
                return false;
            }
            Common.popupDiv("/sales/order/ctAssignmentInfoPop.do", $("#detailForm").serializeJSON(), null , true, '_CTDiv');
        }

    }

    function fn_CTBulk(){
        Common.popupDiv("/sales/order/ctAssignBulkPop.do", $("#detailForm").serializeJSON(), null , true, '_bulkDiv');
    }

    function fn_rawData(){
        Common.popupDiv("/sales/order/orderCancelRequestRawDataPop.do", null, null, true);
    }

    function fn_productReturnRaw(){
        Common.popupDiv("/sales/order/orderCancelProductReturnRawPop.do", null, null, true);
    }

    function fn_productReturnLogBookList(){
        Common.popupDiv("/sales/order/orderCancelProductReturnLogBookListingPop.do", null, null, true);
    }


    function fn_productReturnYSList(){
        Common.popupDiv("/sales/order/orderCancelProductReturnYellowSheetPop.do", null, null, true);
    }


    function fn_productReturnNoteList(){
        Common.popupDiv("/sales/order/orderCancelProductReturnNoteListingPop.do", null, null, true);
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
<h2><spring:message code="sal.page.title.orderCancellation" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newLogResult()"><spring:message code="sal.btn.newLogResult" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newRsoResult()">Add PR Result</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_ctAssignment()"><spring:message code="sal.btn.ctAssignment" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_CTBulk()"><spring:message code="sal.btn.changeAssignCTBulk" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_orderCancelListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#"  onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="detailForm" name="detailForm" method="post">
    <input type="hidden" id="reqId" name="reqId">
    <input type="hidden" id="callEntryId" name="callEntryId">
    <input type="hidden" id="salesOrdId" name="salesOrdId">
    <input type="hidden" id="paramSalesOrdNo" name="paramSalesOrdNo">
    <input type="hidden" id="typeId" name="typeId">
    <input type="hidden" id="docId" name="docId">
    <input type="hidden" id="refId" name="refId">
    <input type="hidden" id="paramCallStusId" name="paramCallStusId">
    <input type="hidden" id="paramCallStusCode" name="paramCallStusCode">
    <input type="hidden" id="paramReqNo" name="paramReqNo">
    <input type="hidden" id="paramReqStusId" name="paramReqStusId">
    <input type="hidden" id="paramReqStusCode" name="paramReqStusCode">
    <input type="hidden" id="paramReqStusName" name="paramReqStusName">
    <input type="hidden" id="paramReqStageId" name="paramReqStageId">
    <input type="hidden" id="paramRsoStusId" name="paramRsoStusId">
</form>
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
        <input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
        <select id="cmbAppTypeId" name="cmbAppTypeId" class="multy_select w100p" multiple="multiple">
        </select>
    </td>
    <th scope="row"><spring:message code="sal.text.requestDate" /></th>
    <td>

        <div class="date_set w100p"><!-- date_set start -->
            <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span><spring:message code="sal.text.to" /></span>
            <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestNo" /></th>
    <td>
        <input type="text" title="" id="reqNo" name="reqNo" placeholder="Request Number" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.callLogStus" /></th>
    <td>
        <select id="callStusId" name="callStusId" class="multy_select w100p" multiple="multiple">
            <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
            <option value="19" selected><spring:message code="sal.combo.text.recall" /></option>
            <option value="32"><spring:message code="sal.combo.text.confirmToCancel" /></option>
            <option value="31"><spring:message code="sal.combo.text.reversalOfCancellation" /></option>
        </select>
    </td>
    <th scope="row"><spring:message code="sal.text.callLogDate" /></th>
    <td>

        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" id="startRecallDt" name="startRecallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span><spring:message code="sal.text.to" /></span>
        <p><input type="text" id="endRecallDt" name="endRecallDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->

    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.requestStage" /></th>
    <td>
    <select id="reqStageId" name="reqStageId" class="multy_select w100p" multiple="multiple">
        <option value="24" selected><spring:message code="sal.text.beforeInstall" /></option>
        <option value="25" selected><spring:message code="sal.text.afterInstall" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
    <td>
        <select id="cmbDscBranchId" name="cmbDscBranchId" class="multy_select w100p" multiple="multiple">
            <c:forEach var="list" items="${dscBranchList }">
               <option value="${list.brnchId }">${list.brnchName }</option>
            </c:forEach>
        </select>
    </td>
    <th scope="row"><spring:message code="sal.text.creator" /></th>
    <td>
    <input type="text" title="" id="crtUserId" name="crtUserId" placeholder="Creator(UserName)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td>
    <input type="text" title="" id="custId" name="custId" placeholder="Customer ID(Number Only)" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td>
    <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td>
    <input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" />
    </td>
</tr>


</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_rawData()"><spring:message code="sal.btn.requestRawData" /></a></p></li>
    </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_productReturnRaw()">Product Return Raw</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_productReturnLogBookList()">Product Return Log Book Listing</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_productReturnYSList()">Product Return YS Listing</a></p></li>
    </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onClick="fn_productReturnNoteList()">Product Return Note</a></p></li>
    </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
