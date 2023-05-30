<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid 생성 후 반환 ID
  var myGridID;
  var basicAuth = false;

  $(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    //AUIGrid.setSelectionMode(myGridID, "singleRow");

    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
      $("#soExchgId").val(event.item.soExchgId);
      $("#exchgType").val(event.item.soExchgTypeId);
      $("#exchgStus").val(event.item.soExchgStusId);
      $("#exchgCurStusId").val(event.item.soCurStusId);
      $("#salesOrderNo").val(event.item.salesOrdNo);
      $("#salesOrderId").val(event.item.soId);
      Common.popupDiv("/sales/order/orderExchangeDetailPop.do", $("#detailForm").serializeJSON());
    });
    // 셀 클릭 이벤트 바인딩

    //Basic Auth (update Btn)
    if ('${PAGE_AUTH.funcChange}' == 'Y') {
      basicAuth = true;
    }
  });

  function createAUIGrid() {
    // AUIGrid 칼럼 설정

    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [
        {
          dataField : "codeName",
          headerText : '<spring:message code="sal.title.type" />',
          width : 160,
          editable : false
        }, {
          dataField : "code",
          headerText : '<spring:message code="sal.title.status" />',
          width : 100,
          editable : false
        }, {
          dataField : "salesOrdNo",
          headerText : '<spring:message code="sal.text.ordNo" />',
          width : 120,
          editable : false
        }, {
          dataField : "salesDt",
          headerText : '<spring:message code="sal.text.ordDate" />',
          dataType : "date",
          formatString : "dd/mm/yyyy",
          width : 130,
          editable : false
        }, {
          dataField : "name",
          headerText : '<spring:message code="sal.title.custName" />',
          editable : false
        }, {
          dataField : "nric1",
          headerText : '<spring:message code="sal.title.text.nricCompNo" />',
          width : 170,
          editable : false
        },{
            dataField : "",
            headerText : "PEX Note",
            width : 150,
            renderer : {
                type : "ButtonRenderer",
                labelText : "View",
                onclick : function(rowIndex, columnIndex, value, item) {
                  //console.log(item);
                  fileDown(item);
                }
            }
            , editable : false
        }, {
          dataField : "soExchgCrtDt",
          headerText : '<spring:message code="sal.text.createDate" />',
          width : 130,
          editable : false
        }, {
          dataField : "crtUserName",
          headerText : '<spring:message code="sal.text.creator" />',
          width : 140,
          editable : false
        }, {
          dataField : "soExchgId",
          visible : false
        }, {
          dataField : "soExchgTypeId",
          visible : false
        }, {
          dataField : "soExchgStusId",
          visible : false
        }, {
          dataField : "soCurStusId",
          visible : false
        }, {
          dataField : "soId",
          visible : false
        },{
            dataField : "resultRepEmailNo",
            headerText : 'resultRepEmailNo',
            width : 130
        },{
            dataField : "emailSentCount",
            headerText : 'emailSentCount',
            width : 130
        }];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      fixedColumnCount : 1,
      showStateColumn : false,
      displayTreeOpen : true,
      selectionMode : "multipleCells",
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : false,
      showRowCheckColumn : true,
      showRowAllCheckBox : true,
      groupingMessage : "Here groupping"
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
  }

  //f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
  doGetCombo('/common/selectCodeList.do', '56', '', 'cmbExcType', 'M', 'f_multiCombo'); // Exchange Type Combo Box
  doGetCombo('/common/selectCodeList.do', '10', '', 'cmbAppType', 'M', 'f_multiCombo'); // Application Type Combo Box

  // 조회조건 combo box
  function f_multiCombo() {
    $(function() {
      $('#cmbExcType').change(function() {

      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '80%'
      });
      $('#cmbAppType').change(function() {

      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '80%'
      });

      $('#cmbExcType').multipleSelect("checkAll");
      $('#cmbAppType').multipleSelect("checkAll");
    });
  }

  function fn_searchListAjax() {
    Common.ajax("GET", "/sales/order/orderExchangeJsonList", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  function fn_rawData() {
    Common.popupDiv("/sales/order/orderExchangeRawDataPop.do", null, null, true);
  }

  function fn_rawData2() {
    Common.popupDiv("/sales/order/orderExchangeRawData2Pop.do", null, null, true);
  }

  function fn_stkRetList() {
    Common.popupDiv("/sales/order/orderExchangeProductReturnPop.do", null, null, true);
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = -1;
      }
    });
  };

  function fileDown(item){
      var V_WHERE = "";

      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();
      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      if(item.code != "COM"){
          Common.alert("PEX Note only allowed for COMPLETED installation.");
          return;
      }

      V_WHERE += item.soId;

      console.log("///V_WHERE");
      console.log(item);
      console.log("/////");

      //SP_CR_GEN_PEX_NOTES
      $("#reportFormPEXLst").append('<input type="hidden" id="V_WHERE" name="V_WHERE"  /> ');

      var option = {
              isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      $("#reportFormPEXLst #V_WHERE").val(V_WHERE);
      $("#reportFormPEXLst #reportFileName").val("/services/PEXNoteDigitalization.rpt");
      $("#reportFormPEXLst #reportDownFileName").val("PEXNoteDigitalization" + day + month + date.getFullYear());
      $("#reportFormPEXLst #viewType").val("PDF");

      Common.report("reportFormPEXLst", option);
  }

  function fn_sendEmail(){
      var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

      if (selectedItems.length <= 0) {
          Common.alert("<spring:message code='service.msg.NoRcd'/> ");
          return;
        }

        if (selectedItems.length > 10) {
          Common.alert("<b>Please select not more than 10 record<b>");
          return;
        }

        var soIdArr = [];
        var notSendArr = [];
        var salesOrdNoSendArr = [];
        var emailArr = [];
        var soIdCountArr = [];
        var salesOrdNoCountSendArr = [];
        var emailCountArr = [];

        for ( var i in selectedItems) {
            var soId = selectedItems[i].item.soId;
            var status = selectedItems[i].item.code;
            var salesOrdNo = selectedItems[i].item.salesOrdNo;
            var resultRepEmailNo = selectedItems[i].item.resultRepEmailNo;
            var emailSentCount = selectedItems[i].item.emailSentCount;

            if(status != 'COM'){
                notSendArr.push(salesOrdNo);
                Common.alert("Email only send for Complete PR");
                return;
            }

            if(resultRepEmailNo == null){
                notSendArr.push(salesOrdNo);
                Common.alert(notSendArr.join(',') + " has empty customer email");
                return;
            }

            if(emailSentCount > 0){
            	soIdCountArr.push(soId);
            	salesOrdNoCountSendArr.push(salesOrdNo);
                emailCountArr.push(resultRepEmailNo);
            }else{
            	soIdArr.push(soId);
                salesOrdNoSendArr.push(salesOrdNo);
                emailArr.push(resultRepEmailNo);
            }
        }

        var emailM = {
        		soIdArr : soIdArr,
        		salesOrdNoSendArr : salesOrdNoSendArr,
                emailArr : emailArr,
                salesOrdNoCountSendArr : salesOrdNoCountSendArr,
                soIdCountArr : soIdCountArr,
                emailCountArr : emailCountArr
        }

        if(emailCountArr.length > 0){
            Common.confirmCustomizingButton("Order No " + salesOrdNoCountSendArr.join(',') + " PEX Notes has been sent 1 time <br> Do you want to send the email again?",
            		"Yes", "No", fn_pexSendEmail, fn_popClose);
        }
        else{
        	fn_pexSendEmail();
        }

        function fn_pexSendEmail(){

            var idArr = [];
            var noArr = [];
            var emailArr = [];

            if(emailM.emailCountArr.length > 0){
                idArr = emailM.soIdArr.concat(emailM.soIdCountArr);
                noArr = emailM.salesOrdNoSendArr.concat(emailM.salesOrdNoCountSendArr);
                emailArr = emailM.emailArr.concat(emailM.emailCountArr);
            }else{
                idArr = emailM.soIdArr;
                noArr = emailM.salesOrdNoSendArr;
                emailArr = emailM.emailArr;
            }

            var sendEmailM = {
                    soIdArr : idArr,
                    salesOrdNoSendArr : noArr,
                    emailArr : emailArr,
            }

            if(idArr.length > 0){
                if(emailArr.length >= 1){
                    Common.ajax("POST", "/sales/order/pexSendEmail.do", sendEmailM, function(result) {
                        console.log(result);
                        if(result.code == '00') {
                            Common.alert(result.message);
                        }
                    });
                }else{
                    Common.alert("Email not sent because Customer email is empty");
                }
            }
        }

        function fn_popClose(){
            return;
         }
  }

</script>
<section id="content">
  <!-- content start -->
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
  </ul>
  <aside class="title_line">
    <!-- title_line start -->
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>
      <spring:message code="sal.title.text.exchangeList" />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span>
            <spring:message code="sal.btn.search" /></a></p></li>
      </c:if>
      <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>
          <spring:message code="sal.btn.clear" /></a></p></li>
    </ul>
  </aside>
  <!-- title_line end -->
  <section class="search_table">
    <!-- search_table start -->
    <form id="detailForm" name="detailForm" method="post">
      <input type="hidden" id="soExchgId" name="soExchgId"> <input type="hidden" id="exchgType" name="exchgType"> <input type="hidden" id="exchgStus" name="exchgStus"> <input type="hidden" id="exchgCurStusId" name="exchgCurStusId">
      <!--     <input type="hidden" id="salesOrdNo" name="salesOrdNo"> -->
      <input type="hidden" id="salesOrderId" name="salesOrderId">
    </form>

    <form id='reportFormPEXLst' method="post" name='reportFormPEXLst' action="#">
	    <input type='hidden' id='reportFileName' name='reportFileName'/>
	    <input type='hidden' id='viewType' name='viewType'/>
	    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
	    <input type='hidden' id='V_TEMP' name='V_TEMP'/>
    </form>

    <form id="searchForm" name="searchForm" method="post">
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
          <col style="width: 170px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="sal.title.text.exchangeType" /></th>
            <td>
              <select id="cmbExcType" name="cmbExcType" class="multy_select w100p" multiple="multiple">
              </select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.exchangeStatus" /></th>
            <td>
              <select id="cmbExcStatus" name="cmbExcStatus" class="multy_select w100p" multiple="multiple">
                <option value="1" selected><spring:message code="sal.btn.active" /></option>
                <option value="4"><spring:message code="sal.combo.text.compl" /></option>
                <option value="10"><spring:message code="sal.combo.text.cancel" /></option>
              </select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.requestDate" /></th>
            <td>
              <div class="date_set w100p">
                <!-- date_set start -->
                <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date" /></p> <span><spring:message code="sal.title.to" /></span>
                <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
              </div>
              <!-- date_set end -->
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.ordNum" /></th>
            <td>
              <input type="text" id="salesOrdNo" name="salesOrdNo" title="" placeholder="Order Number" class="w100p" />
            </td>
            <th scope="row"><spring:message code="sal.text.appType" /></th>
            <td>
              <select id="cmbAppType" name="cmbAppType" class="multy_select w100p" multiple="multiple">
              </select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.requestor" /></th>
            <td>
              <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Requestor (Username)" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="sal.text.customerId" /></th>
            <td>
              <input type="text" title="" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p" />
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
      </table>
      <!-- table end -->
      <aside class="link_btns_wrap">
        <!-- link_btns_wrap start -->
        <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
        <dl class="link_list">
          <dt>
            <spring:message code="sal.title.text.link" />
          </dt>
          <dd>
            <ul class="btns">
              <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <li><p class="link_btn type2"><a href="#" onClick="fn_rawData()"><spring:message code="sal.title.text.exchangeRawData" /></a></p></li>
              </c:if>
              <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
                <li><p class="link_btn type2"><a href="#" onClick="fn_rawData2()"><spring:message code="sal.title.text.exchangeRawData" /> - (HQ Format)</a></p></li>
              </c:if>
              <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                <li><p class="link_btn type2"><a href="#" onClick="fn_stkRetList()"><spring:message code="sal.title.text.exchangeStkRet" /></a></p></li>
              </c:if>
            </ul>
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
          </dd>
        </dl>
      </aside>
      <!-- link_btns_wrap end -->
    </form>
  </section>
  <!-- search_table end -->

  <section class="search_result">
   <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_sendEmail()">Send Email</a>
      </p></li>
    </c:if>
    <!--  <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
   </ul>
    <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="list_grid_wrap" style="width: 100%;
  height: 480px;
  margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
  </section>
  <!-- search_result end -->
</section>
<!-- content end -->
