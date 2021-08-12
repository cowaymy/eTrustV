<!--=================================================================================================
* Task  : Sales
* File Name : orderSummary.jsp
* Description : Order Summary
* Author : KR-OHK
* Date : 2019-10-02
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-02  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    var myGridID;
    var IS_3RD_PARTY = '${SESSION_INFO.userIsExternal}';

    var columnLayout = [
   {
        dataField: "ordNo",
        headerText: "<spring:message code='sal.text.ordNo' />",
        editable: false,
        visible: true,
        width : 100,
        dataType: "date",
        formatString: "dd/mm/yyyy"
    }
    ,{
        dataField: "custVaNo",
        headerText: "<spring:message code='sal.text.vaNumber'/>",
        editable: false,
        visible: true,
        width : 140
    }
    ,{
        dataField: "custName",
        headerText: "<spring:message code='sal.text.custName' />",
        editable: false,
        visible: true,
        width : 200,
        style: "aui-grid-user-custom-left"
    }
    ,{
        dataField: "jomPayRef",
        headerText: "<spring:message code='sal.text.jomPayRef1'/>",
        editable: false,
        visible: true,
        width : 110
    }
    ,{
        dataField: "corpTypeId",
        headerText: "<spring:message code='sal.title.text.corpType'/>",
        width : "5%",
        editable: false,
        visible: true
    }
    ,{
        dataField: "custType",
        headerText: "<spring:message code='sal.text.custType'/>",
        width : 120,
        editable: false,
        visible: true,
        //style: "aui-grid-user-custom-left"
    }
    ,{
    	dataField: "custId",
        headerText: "<spring:message code='sal.text.customerId'/>",
        editable: false,
        visible: true,
        width : 100
    }
    ,{
        dataField: "ordStusCode",
        headerText: "<spring:message code='sal.title.text.ordStus' />",
        width : 100,
        editable: false,
        visible: true
    }
    ,{
        dataField: "ordDt",
        headerText: "<spring:message code='sal.text.ordDate'/>",
        width : 90,
        editable: false,
        visible: true,
        dataType: "date",
        formatString: "dd/mm/yyyy"
    }
    ,{
        dataField: "instArea",
        headerText: "<spring:message code='sal.text.area'/>",
        width :140,
        editable: false,
        visible: true,
        style: "aui-grid-user-custom-left"
    }
    ,{
        dataField: "instState",
        headerText: "<spring:message code='sal.text.state'/>",
        width : 120,
        editable: false,
        visible: true,
        style: "aui-grid-user-custom-left"
     }
    ,{
        dataField: "stkCode",
        headerText: "<spring:message code='sal.title.text.product' />",
        width : 250,
        editable: false,
        visible: true,
        style: "aui-grid-user-custom-left"
    }
    ,{
        dataField: "appTypeCode",
        headerText: "<spring:message code='sal.title.text.appType' />",
        width : 80,
        editable: false,
        visible: true
    }
    ,{
        dataField: "rentPayModeDesc",
        headerText: "<spring:message code='sal.title.text.payMode'/>",
        editable: false,
        visible: true,
        width : 90
    }
    ,{
        dataField: "rentalStus",
        headerText: "<spring:message code='sal.head.currentStatus'/>",
        width : 120,
        editable: false,
        visible: true
    }
    ,{
        dataField: "norRntFee",
        headerText: "<spring:message code='sal.title.text.normalRentalFees'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "currMthChrg",
        headerText: "<spring:message code='sal.head.currMthChrg'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "currNoMonthOfRentalBill",
        headerText: "<spring:message code='sal.head.currNoMonthOfRentalBill'/>",
        width : 150,
        editable: false,
        visible: true
    }
    ,{
        dataField: "rentCurrOtstnd",
        headerText: "<spring:message code='sal.head.rentCurrOtstnd'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "rpfBillAmt",
        headerText: "<spring:message code='sal.head.rpfBillAmt'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "rpfPayAmt",
        headerText: "<spring:message code='sal.head.rpfPayAmt'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "rpfAdjAmt",
        headerText: "<spring:message code='sal.head.rpfAdjAmt'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "ordUnbillAmt",
        headerText: "<spring:message code='sal.title.text.unbillAmt'/>",
        width : 120,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "webRentLedger",
        headerText: "<spring:message code='sal.head.webRentLedger'/>",
        width : 180,
        editable: false,
        visible: true,
        dataType:"numeric",
        formatString:"#,##0.00",
        style: "aui-grid-user-custom-right"
    }
    ,{
        dataField: "ordLastPayDt",
        headerText: "<spring:message code='sal.title.text.payDate'/>",
        editable: false,
        visible: true,
        width : 90,
        dataType: "date",
        formatString: "dd/mm/yyyy"
    }
    ,{
        dataField: "custBillGrpNo",
        headerText: "<spring:message code='sal.title.groupNo'/>",
        width : 100,
        editable: false,
        visible: true
    }
    ,{
        dataField: "rentalBillNo",
        headerText: "<spring:message code='sal.head.rentalBillNo'/>",
        width : 120,
        editable: false,
        visible: true
    }
    ,{
        dataField: "srvCntrctNo",
        headerText: "<spring:message code='commissiom.text.excel.rcvCntrctNo'/>",
        width : 120,
        editable: false,
        visible: true
    }
    ,{
        dataField: "appTypeDesc",
        headerText: "<spring:message code='sal.text.appType'/>",
        width : 140,
        editable: false,
        visible: true
    }
    ,{
        dataField : "orgCode",
        headerText : "<spring:message code='sal.text.orgCode' />",
        width : 100,
        editable : false,
        style: 'left_style'
    }
    , {
        dataField : "grpCode",
        headerText : "<spring:message code='sal.text.grpCode' />",
        width : 100,
        editable : false,
        style: 'left_style'
    }
    , {
        dataField : "deptCode",
        headerText : "<spring:message code='sal.text.detpCode' />",
        width : 100,
        editable : false
    }
    , {
        dataField : "ordMemCode",
        headerText : "<spring:message code='sal.text.salManCode' />",
        width : 120,
        editable : false
    }
    , {
        dataField : "ordMemName",
        headerText : "<spring:message code='sal.text.salManName' />",
        width : 180,
        editable : false,
        style: "aui-grid-user-custom-left"
    }
    , {
        dataField : "ordPromoCode",
        headerText : "<spring:message code='sal.text.promotionCode' />",
        width : 140,
        editable : false
    }
    , {
        dataField : "ordPromoDesc",
        headerText : "<spring:message code='sales.promo.promoNm' />",
        width : 200,
        editable : false,
        style: "aui-grid-user-custom-left"
    }
    , {
        dataField : "netSaleMonth",
        headerText : "<spring:message code='sal.text.netSalesMonth' />",
        width : 120,
        editable : false
    }
    ];

    // 그리드 속성 설정
    var gridPros = {
        // 페이징 사용
        usePaging: true,
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount: 20,
        editable: false,
        showStateColumn: false,
        displayTreeOpen: true,
        selectionMode: "multipleCells",
        headerHeight: 30,
        // 그룹핑 패널 사용
        useGroupingPanel: false,
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns: true,
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove: true,
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn: true
    };

    $(document).ready(function () {

    	$("#orgCode").val($("#orgCode").val().trim());

    	if($("#memType").val() == 1 || $("#memType").val() == 2){
            if("${SESSION_INFO.memberLevel}" =="1"){

                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="2"){

                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="3"){

                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="4"){

                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                $("#memCode").val("${memCode}");
                $("#memCode").attr("class", "w100p readonly");
                $("#memCode").attr("readonly", "readonly");
            }
        }

    	myGridID = GridCommon.createAUIGrid("grid_sum_list", columnLayout,'',gridPros);

        CommonCombo.make('cmbAppType', '/common/selectCodeList.do', {groupCode : 10} , '', {type: 'M'});
        doGetComboWh('/sales/order/colorGridProductList.do', '', '', 'cmbProduct', '', '');

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            if(IS_3RD_PARTY == '0') {
                fn_setDetail(myGridID, event.rowIndex);
            }
            else {
                Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
            }
        });

        //excel Download
        $('#excelDown').click(function() {
           GridCommon.exportTo("grid_sum_list", 'xlsx', "Order Summary");
        });

        $("#orgCode").bind("keyup", function()
   	    {
   	      $(this).val($(this).val().toUpperCase());
   	    });
        $("#grpCode").bind("keyup", function()
        {
          $(this).val($(this).val().toUpperCase());
        });
        $("#deptCode").bind("keyup", function()
        {
          $(this).val($(this).val().toUpperCase());
        });
        $("#custName").bind("keyup", function()
        {
          $(this).val($(this).val().toUpperCase());
        });
        $("#salesmanCode").bind("keyup", function()
        {
          $(this).val($(this).val().toUpperCase());
        });
        $("#promoCode").bind("keyup", function()
	    {
	      $(this).val($(this).val().toUpperCase());
	    });
        $("#groupNo").bind("keyup", function()
        {
          $(this).val($(this).val().toUpperCase());
        });
    });

    function fn_setDetail(gridID, rowIdx){
        Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null, true, "_divIdOrdDtl");
    }

    // 리스트 조회.
    function fn_selectOrderSummary() {

    	if(FormUtil.checkReqValue($("#ordNo")) && FormUtil.checkReqValue($("#custIc")) && FormUtil.checkReqValue($("#groupNo"))) {
    		if(FormUtil.checkReqValue($("#createStDate")) && FormUtil.checkReqValue($("#createEnDate")) &&
	                FormUtil.checkReqValue($("#netSalesMonth"))  ){
    			Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastOrdDateNetSales'/>");
                return;
	        }
            if(FormUtil.diffDay($("#createStDate").val(), $("#createEnDate").val()) > 15){
                Common.alert("Order Date is only within 15 days.");
                return ;
            }
    	}

    	Common.ajax("GET", "/sales/order/selectOrderSummary", $("#searchForm").serialize(), function (result) {
        	AUIGrid.setGridData(myGridID, result);
        });
    }

    //def Combo(select Box OptGrouping)
    function doGetComboWh(url, groupCd , selCode, obj , type, callbackFn){

      $.ajax({
          type : "GET",
          url : url,
          data : { groupCode : groupCd},
          dataType : "json",
          contentType : "application/json;charset=UTF-8",
          success : function(data) {
             var rData = data;
             Common.showLoader();
             fn_otpGrouping(rData, obj)
          },
          error: function(jqXHR, textStatus, errorThrown){
              alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
          },
          complete: function(){
              Common.removeLoader();
          }
      });
    } ;

    function fn_otpGrouping(data, obj){

       var targetObj = document.getElementById(obj);

       for(var i=targetObj.length-1; i>=0; i--) {
              targetObj.remove( i );
       }

       obj= '#'+obj;

       // grouping
       var count = 0;
       $.each(data, function(index, value){

           if(index == 0){
              $("<option />", {value: "", text: 'Choose One'}).appendTo(obj);
           }

           if(index > 0 && index != data.length){
               if(data[index].groupCd != data[index -1].groupCd){
                   $(obj).append('</optgroup>');
                   count = 0;
               }
           }

           if(data[index].codeId == null  && count == 0){
               $(obj).append('<optgroup label="">');
               count++;
           }
           if(data[index].codeId == 736 && count == 0){
               $(obj).append('<optgroup label="Air Purifier">');
               count++;
           }
           if(data[index].codeId == 110  && count == 0){
               $(obj).append('<optgroup label="Bidet">');
               count++;
           }
           if(data[index].codeId == 790 && count == 0){
               $(obj).append('<optgroup label="Juicer">');
               count++;
           }
           //
           if(data[index].codeId == 856 && count == 0){
               $(obj).append('<optgroup label="Point Of Entry ">');
               count++;
           }
           if(data[index].codeId == 538 && count == 0){
               $(obj).append('<optgroup label="Softener ">');
               count++;
           }
           if(data[index].codeId == 217 && count == 0){
               $(obj).append('<optgroup label="Water Purifier ">');
               count++;
           }

           $('<option />', {value : data[index].codeId, text: data[index].codeName}).appendTo(obj); // WH_LOC_ID


           if(index == data.length){
               $(obj).append('</optgroup>');
           }
       });
       //optgroup CSS
       $("optgroup").attr("class" , "optgroup_text");

    }

   $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password'  || tag === 'textarea'){
                if($("#"+this.id).hasClass("readonly")){

                }else{
                    this.value = '';
                }
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = -1;
            }
        });
    };
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Order Summary</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectOrderSummary();"><span  class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm" action="#" method="post">
            <input type="hidden" name="memType" id="memType" value="${memType}"/>
            <input type="hidden" name="memCode" id="memCode" />
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
					    <th scope="row"><spring:message code="sal.title.text.orgCode" /></th>
					    <td>
					    <input type="text" title="" id="orgCode" name="orgCode" value="${orgCode}" placeholder="Organization Code" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.groupCode" /></th>
					    <td>
					    <input type="text" title="" id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.deptCode" /></th>
					    <td>
					    <input type="text" title="" id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
					    </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code='sal.text.ordNo' /></th>
					    <td>
					    <input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code="sales.custId2" /></th>
					    <td>
					    <input type="text" title="" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p" onkeydown="return FormUtil.onlyNumber(event)" />
					    </td>
					    <th scope="row"><spring:message code="sal.text.custName" /></th>
                        <td>
                        <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
                        </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code="sal.text.appType" /></th>
					    <td>
					    <select class="multy_select w100p" id="cmbAppType" name="cmbAppType" multiple="multiple">
					    </select>
					    </td>
					    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
					    <td>
					    <div class="date_set w100p"><!-- date_set start -->
					    <p><input type="text" title="Create start Date" id="createStDate" name="createStDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
					    <span><spring:message code="sal.text.to" /></span>
					    <p><input type="text" title="Create end Date" id="createEnDate" name="createEnDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
					    </div><!-- date_set end -->
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
                        <td>
                        <input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" />
                        </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code="sal.text.netSalesMonth" /></th>
					    <td><input type="text" title="" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
					    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
					    <td>
					    <input type="text" title="" id="salesmanCode" name="salesmanCode" placeholder="Salesman (Member Code)" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code="sal.title.text.product" /></th>
                        <td>
                        <select class="w100p" id="cmbProduct" name="cmbProduct">
                        </select>
                        </td>
					</tr>
					<tr>
					    <th scope="row"><spring:message code="sal.text.condition" /></th>
					    <td>
					    <select class="w100p" id="cmbCondition" name="cmbCondition">
					        <option value="">Choose One</option>
					        <option value="1"><spring:message code="sal.combo.text.active" /></option>
					        <option value="2"><spring:message code="sal.combo.text.cancel" /></option>
					        <option value="3"><spring:message code="sal.combo.text.netSales" /></option>
					        <option value="4"><spring:message code="sal.combo.text.yellowSheet" /></option>
					        <option value="5"><spring:message code="sal.combo.text.installFailed" /></option>
					        <option value="6"><spring:message code="sal.combo.text.installActive" /></option>
					    </select>
					    </td>
					    <th scope="row"><spring:message code="sal.text.promotionCode" /></th>
					    <td>
					    <input type="text" title="" id="promoCode" name="promoCode" placeholder="Promotion Code" class="w100p" />
					    </td>
					    <th scope="row"><spring:message code='sal.title.groupNo'/></th>
					    <td><input type="text" title="" id="groupNo" name="groupNo" placeholder="Bill Group No" class="w100p" /></td>
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
            <div id="grid_sum_list" style="width:100%; height:100%; margin:0 auto;" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->

