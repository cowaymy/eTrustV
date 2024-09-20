<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
	//AUIGrid ID
	var myGridID;
	var excelListGridID;
	var itemDtlListGridID;

	$(document).ready(function() {
        createAUIGrid();
        createExcelAUIGrid();
        createItemDtlAUIGrid();

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            var detailParam = {
                 ordId : event.item.ordId
           };

            Common.ajax("GET", "/supplement/colorGrid/getSupplementDetailList", detailParam, function(result) {
                AUIGrid.setGridData(itemDtlListGridID, result);
           });
        });

        $("#orgCode").val($("#orgCode").val().trim());
        $("#memLvl").val("${SESSION_INFO.memberLevel}");

         if($("#memType").val() == 1 || $("#memType").val() == 2 || $("#memType").val() == 7){
        	if("${SESSION_INFO.memberLevel}" =="0"){
                $("#memtype").val('${SESSION_INFO.userTypeId}');
                $("#memtype").attr("class", "w100p readonly");
                $('#memtype').attr('disabled','disabled').addClass("disabled");
            }else if("${SESSION_INFO.memberLevel}" =="1"){
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

                if($("#memType").val() == "7"){ //HTM
                   $("#memtype option[Value='"+$("#memType").val()+"']").attr("selected", true);
                   $("#memtype").attr("class", "w100p readonly");
                   $('#memtype').attr('disabled','disabled').addClass("disabled");
                }
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

                if($("#memType").val() == "7"){  // HT
	                $("#salesmanCode").val('${SESSION_INFO.userName}');
	                $("#salesmanCode").attr("class", "w100p readonly");
	                $("#salesmanCode").attr("readonly", "readonly");

	                $("#memtype option[Value='"+$("#memType").val()+"']").attr("selected", true);
	                $("#memtype").attr("class", "w100p readonly");
	                $('#memtype').attr('disabled','disabled').addClass("disabled");
                }
            }
        }

        doGetCombo('/common/selectCodeList.do', '8', '','cmbCustomerType', 'M' , 'f_multiCombo');  // Customer Type Combo Box

        $("#cmbProduct").multipleSelect("checkAll");
        $('#cmbAppType').multipleSelect("checkAll");
        $('#cmbProductCtgry').multipleSelect("checkAll");

        $('#excelDown').click(function() {
            var excelProps = {
                fileName     : "color_grid",
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
            };
            AUIGrid.exportToXlsx(excelListGridID, excelProps);
        });
    });


	// combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbCustomerType').change(function() {
            }).multipleSelect({
                selectAll: true,
                width: '80%'
            });

            $('#cmbProduct').change(function() {
            }).multipleSelect({
                selectAll: true,
                width: '80%'
            });
        });
    }

	function createAUIGrid() {
        // AUIGrid
        var columnLayout = [
            {
                dataField : "ordNo",
                headerText : "<spring:message code='supplement.title.text.ordNo' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordStatus",
                headerText : "<spring:message code='sal.title.text.ordStus' />",
                width : 250,
                editable : false,
                style: 'left_style'
            },{
                dataField : "ordStage",
                headerText : "<spring:message code='sal.title.text.ordStus' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "appType",
                headerText : "<spring:message code='supplement.title.text.appType' />",
                width : 150,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custName",
                headerText : "<spring:message code='supplement.title.text.custName' />",
                width : 250,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "salesmanCode",
                headerText : "<spring:message code='supplement.title.text.salManCode' />",
                width : 120,
                editable : false,
                style: 'left_style'
            },  {
                dataField : "deliveryStatus",
                headerText : "<spring:message code='supplement.text.supplementDeliveryStatus' />",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "keyInMonth",
                headerText : "Key In Month",
                width : 100,
                editable : false,
                style: 'left_style'
            },{
                dataField : "netMonth",
                headerText : "<spring:message code='supplement.title.text.netSalesMonth' />",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "orgCode",
                headerText : "<spring:message code='supplement.title.text.orgCode' />",
                width : 150,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "grpCode",
                headerText : "<spring:message code='supplement.title.text.groupCode' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "deptCode",
                headerText : "<spring:message code='supplement.title.text.deptCode' />",
                width : 150,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "returnDeliveryStatus",
                headerText : "<spring:message code='supplement.title.text.returnDeliveryStus' />",
                width : 180,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordId",
                visible : false
            }, {
                dataField : "isRefund",
                headerText : "<spring:message code='supplement.title.text.refund' />",
                width : 100,
                editable : false,
                style: 'left_style'
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
            groupingMessage : "Here groupping"
        };


        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

	  function createExcelAUIGrid() {
		   var excelColumnLayout = [{
               dataField : "ordNo",
               headerText : "<spring:message code='supplement.title.text.ordNo' />",
               width : 100,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "ordStatus",
               headerText : "<spring:message code='sal.title.text.ordStus' />",
               width : 250,
               editable : false,
               style: 'left_style'
           },{
               dataField : "ordStage",
               headerText : "<spring:message code='sal.title.text.ordStus' />",
               width : 100,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "appType",
               headerText : "<spring:message code='supplement.title.text.appType' />",
               width : 150,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "custName",
               headerText : "<spring:message code='supplement.title.text.custName' />",
               width : 250,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "salesmanCode",
               headerText : "<spring:message code='supplement.title.text.salManCode' />",
               width : 120,
               editable : false,
               style: 'left_style'
           },  {
               dataField : "deliveryStatus",
               headerText : "<spring:message code='supplement.text.supplementDeliveryStatus' />",
               width : 120,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "keyInMonth",
               headerText : "Key In Month",
               width : 100,
               editable : false,
               style: 'left_style'
           },{
               dataField : "netMonth",
               headerText : "<spring:message code='supplement.title.text.netSalesMonth' />",
               width : 120,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "orgCode",
               headerText : "<spring:message code='supplement.title.text.orgCode' />",
               width : 150,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "grpCode",
               headerText : "<spring:message code='supplement.title.text.groupCode' />",
               width : 100,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "deptCode",
               headerText : "<spring:message code='supplement.title.text.deptCode' />",
               width : 150,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "returnDeliveryStatus",
               headerText : "<spring:message code='supplement.title.text.returnDeliveryStus' />",
               width : 180,
               editable : false,
               style: 'left_style'
           }, {
               dataField : "ordId",
               visible : false
           }, {
               dataField : "isRefund",
               headerText : "<spring:message code='supplement.title.text.refund' />",
               width : 100,
               editable : false,
               style: 'left_style'
           }];

	        var excelGridPros = {
	             enterKeyColumnBase : true,
	             useContextMenu : true,
	             enableFilter : true,
	             showStateColumn : true,
	             displayTreeOpen : true,
	             noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
	             groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
	             exportURL : "/common/exportGrid.do"
	         };

	        excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
	    }

	function createItemDtlAUIGrid(){
        var itemDtlColumnLayout = [
           {
                dataField : "itemCode",
                headerText : "<spring:message code='supplement.title.text.itemCode' />",
                width : '10%',
                editable : false
            },
            {
                dataField : "itemDesc",
                headerText : "<spring:message code='supplement.title.text.itemDesc' />",
                width : '60%',
                editable : false
            },
            {
                  dataField : "quantity",
                  headerText : "<spring:message code='supplement.title.text.quantity' />",
                  width : '10%',
                  editable : false
            },
            {
                  dataField : "unitPrice",
                  headerText : "<spring:message code='supplement.title.text.unitPrice' />",
                  width : '10%',
                  editable : false,
                  dataType : "numeric",
                  formatString : "#,##0.00"
            },
            {
                dataField : "totalAmount",
                headerText : "<spring:message code='supplement.title.text.totAmt' />",
                width : '10%',
                editable : false,
                dataType : "numeric",
                formatString : "#,##0.00"
          }];


         var itemDtlGridPros = {
              noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
        	  showFooter : true,
              usePaging : true,
              pageRowCount : 10,
              fixedColumnCount : 1,
              showStateColumn : true,
              displayTreeOpen : false,
              headerHeight : 30,
              useGroupingPanel : false,
              skipReadonlyColumns : true,
              wrapSelectionMove : true,
              showRowNumColumn : true
          };

         itemDtlListGridID = GridCommon.createAUIGrid("itm_detail_grid_wrap", itemDtlColumnLayout, "", itemDtlGridPros);

         var footerLayout = [ {
             labelText : "Total",
             positionField : "#base"
           },
           {
             dataField : "totalAmount",
             positionField : "totalAmount",
             operation : "SUM",
             formatString : "#,##0.00",
             style : "aui-grid-my-footer-sum-total2"
           } ];

          AUIGrid.setFooter(itemDtlListGridID, footerLayout);
	}

    function fn_searchListAjax(){
         //  lev 1  Order Date    Order Date
        //  lev 2   netSalesMonth
        console.log("searchColorGrid");
        var isValid = true;
        if(FormUtil.isEmpty($("#ordNo").val())  &&  FormUtil.isEmpty($("#contactNum").val())
        	&& FormUtil.isEmpty($("#salesmanCode").val()) && FormUtil.isEmpty($("#custIc").val()) ){

	        if ($("#netSalesMonth").val() ==""  &&  $("#createStDate").val()  =="" ){
	        	isValid = false;
	        }

	        if (($("#createStDate").val()  =="" && $("#createEnDate").val()  =="") &&  $("#netSalesMonth").val() ==""){
	        	isValid = false;
	        }

	        if ($("#netSalesMonth").val() ==""){
	        	 if($("#createStDate").val() =="" || $("#createEnDate").val()  ==""){
	        		 isValid = false;
	        	 }
	        	  var startDate = $('#createStDate').val();
	              var endDate = $('#createEnDate').val();
	              if( fn_getDateGap(startDate , endDate) > 365){
	                  Common.alert("Start date can not be more than 365 days before the end date.");
	                  return;
	              }
	        }

	        if ($("#keyInMonth").val() == ""){
	        	 if(($("#createStDate").val() =="" || $("#createEnDate").val() =="") && $("#netSalesMonth").val() ==""){
                     isValid = false;
                 }
	        }else{
	        	var keyInMonth = $("#keyInMonth").val();
	        	var keyInMonthArr = keyInMonth.split('/');
	        	$("#keyinMon").val(keyInMonthArr[0]);
	        	$("#keyinYear").val(keyInMonthArr[1]);

	        	isValid = true;
	        }
        }

          if(isValid == true){
        	var param =  $("#searchForm").serialize();
            var htMemberType = $('#memtype').find('option:selected').val();
        	if('${SESSION_INFO.memberLevel}' =="3" || '${SESSION_INFO.memberLevel}' =="4"){
        		 if(htMemberType == "7"){ // HTM & HT
           			    param += "&memtype="+htMemberType;
        		 }
        	}

	       	Common.ajax("GET", "/supplement/colorGrid/supplementColorGridJsonList", param, function(result) {
	            AUIGrid.setGridData(myGridID, result);
	            AUIGrid.setGridData(excelListGridID, result);

	            AUIGrid.update(myGridID);
	        });

           }else{
               Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastOrdDateNetSales' />");
               return ;
           }
    }

    function fn_getDateGap(sdate, edate){
        var startArr, endArr;

        startArr = sdate.split('/');
        endArr = edate.split('/');

        var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
        var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);

        var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;

        return gap;
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
            	if($("#memType").val() != "7"){ //check not HT level
            		 this.selectedIndex = 0;
            	}
            }

            $("#cmbCustomerType").multipleSelect("uncheckAll");
            $("#cmbProduct").multipleSelect("checkAll");
            $('#cmbAppType').multipleSelect("checkAll");
            $('#cmbProductCtgry').multipleSelect("checkAll");
        });
    };

    $(function(){
    	$('#btnFinanceColorGrid').click(function(){
    		$("#dataForm1").show();
    		 var date = new Date().getDate();
             if(date.toString().length == 1){
                 date = "0" + date;
             }

            $("#downFileNameFinanceRpt").val("SupplementFinanceColorGridReport_" +date+(new Date().getMonth()+1)+new Date().getFullYear());
    		fn_report();
    	});

    });

   function fn_report() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm1", option);
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
<h2><spring:message code="supplement.title.colorGrid" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="supplement.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="supplement.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="dataForm1">
    <input type="hidden" id="fileName" name="reportFileName" value="/supplement/SupplementFinanceColorGrid.rpt"/>
    <input type="hidden" id="viewType" name="viewType" value="EXCEL"/>
    <input type="hidden" id="downFileNameFinanceRpt" name="reportDownFileName" value="" />
</form>

<section class="search_table"><!-- search_table start -->
  <form id="searchForm" name="searchForm" method="post">
    <input type="hidden" name="ordId" id="OrdId" >
    <input type="hidden" name="memType" id="memType" value="${memType}"/>
    <input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode}"/>
    <input type="hidden" name="memCode" id="memCode" />
    <input type="hidden" name="keyinMon" id="keyinMon" />
    <input type="hidden" name="keyinYear" id="keyinYear" />
    <input type="hidden" name="memLvl" id="memLvl"/>
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="supplement.title.text.orgCode" /></th>
        <td>
        <input type="text" title="" id="orgCode" name="orgCode" onkeyup="this.value = this.value.toUpperCase();" value="${orgCode}" placeholder="Organization Code" class="w100p" />
        </td>
        <th scope="row"><spring:message code="supplement.title.text.groupCode" /></th>
        <td>
        <input type="text" title="" id="grpCode" name="grpCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Group Code" class="w100p" />
        </td>
        <th scope="row"><spring:message code="supplement.title.text.deptCode" /></th>
        <td>
        <input type="text" title="" id="deptCode" name="deptCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Department Code" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code='supplement.title.text.ordNo' /></th>
        <td>
        <input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" />
        </td>
        <th scope="row"><spring:message code="supplement.title.text.appType" /></th>
        <td>
           <select id="cmbAppType" name="cmbAppType" class="multy_select w100p" multiple="multiple">
           <c:forEach var="list" items="${appTypeList}" varStatus="status">
             <c:choose>
               <c:when test="${list.code=='OOUT'}">
                 <option value="${list.codeId}" selected>${list.codeName}</option>
               </c:when>
               <c:otherwise>
                 <option value="${list.codeId}">${list.codeName}</option>
               </c:otherwise>
             </c:choose>
            </c:forEach>
           </select>
        </td>
        <th scope="row"><spring:message code="supplement.title.text.ordDate" /></th>
        <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Create start Date" id="createStDate" name="createStDate" placeholder="DD/MM/YYYY" class="j_date" /></p>
        <span><spring:message code="supplement.title.text.ordDateTo" /></span>
        <p><input type="text" title="Create end Date" id="createEnDate" name="createEnDate" placeholder="DD/MM/YYYY" class="j_date" /></p>
        </div><!-- date_set end -->
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="supplement.title.text.custType" /></th>
        <td>
        <select class="multy_select w100p" id="cmbCustomerType" name="cmbCustomerType" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="supplement.title.text.custName" /></th>
        <td>
        <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
        </td>
        <th scope="row"><spring:message code="supplement.title.text.nricCompNo" /></th>
        <td>
        <input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="supplement.title.text.productCategory" /></th>
        <td>
           <select class="multy_select w100p" id="cmbProductCtgry" name="cmbProductCtgry" multiple="multiple">
           <c:forEach var="list" items="${productCategoryList}" varStatus="status">
             <c:choose>
               <c:when test="${list.code=='FS'}">
                 <option value="${list.code}" selected>${list.codeName}</option>
               </c:when>
               <c:otherwise>
                 <option value="${list.code}">${list.codeName}</option>
               </c:otherwise>
             </c:choose>
            </c:forEach>
           </select>
        </td>
        <th scope="row"><spring:message code="supplement.title.text.product" /></th>
        <td>
           <select class="multy_select w100p" id="cmbProduct" name="cmbProduct" multiple="multiple">
              <c:forEach var="list" items="${productList}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
              </c:forEach>
           </select>
        </td>
        <th scope="row"><spring:message code="supplement.title.text.netSalesMonth" /></th>
        <td><input type="text" title="기준년월" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="supplement.title.text.keyInMonth" /></th>
        <td><input type="text" title="" id="keyInMonth" name="keyInMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
        <th scope="row"><spring:message code="supplement.title.text.memtype" /></th>
        <td>
        <select class="w100p" id="memtype" name="memtype">
            <option value="">Choose One</option>
            <option value="2"><spring:message code="supplement.title.text.cowayLady" /></option>
            <option value="1"><spring:message code="supplement.title.text.healthPlanner" /></option>
            <option value="4"><spring:message code="supplement.title.text.staff" /></option>
            <option value="7"><spring:message code="supplement.title.text.homecareTechnician" /></option>
        </select>
        </td>
         <th scope="row"><spring:message code="supplement.title.text.salManCode" /></th>
         <td>
           <input type="text" title="" id="salesmanCode" name="salesmanCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Salesman (Member Code)" class="w100p" />
        </td>
    </tr>
    <tr>
        <th scope="row" colspan="6" ><spaxn class="must"> <spring:message code="sal.alert.msg.youMustKeyInatLeastOrdDateNetSales" /></span>  </th>
    </tr>
    </tbody>
    </table><!-- table end -->
  </form>
  <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
      <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
      <dl class="link_list">
          <dt>Link</dt>
          <dd>
           <ul class="btns">
              <li><p class="link_btn"><a href="#" id="btnFinanceColorGrid"><spring:message code='supplement.btn.financeColorGrid'/></a></p></li>
           </ul>

          <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
          </dd>
      </dl>
   </aside> <!-- link_btns_wrap end  -->
 </section><!-- search_table end -->

  <section class="search_result"><!-- search_result start -->
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
      <ul class="right_btns">
          <li><p class="btn_grid"><a href="#" id="excelDown">GENERATE</a></p></li>
      </ul>
      </c:if>

      <article class="grid_wrap"><!-- grid_wrap start -->
          <div id="list_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
          <div id="excel_list_grid_wrap" style="display: none;"></div>
      </article><!-- grid_wrap end -->

      <div id="itemDetailGridDiv">
          <article class="grid_wrap">
            <div id="itm_detail_grid_wrap" style="width: 100%; height: 200px; margin: 0 auto;"></div>
          </article>
       </div>
  </section><!-- search_result end -->

</section><!-- content end -->