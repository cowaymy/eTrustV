<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE              BY         VERSION        REMARK
 ----------------------------------------------------------------
19/08/2020     TOMMY      1.0.0           CREATED NEW JSP FOR WATER ENVIRONMENT
 -->

<script type="text/javaScript">

  $(document).ready(
    function() {
     doGetCombo('/services/getProductList.do', '', '', 'product', 'S', '');
    doGetCombo('/sales/customer/selectMagicAddressComboList', '', '', 'resultState', 'S', '');
    //doDefCombo(emptyData, '', 'resultArea', 'S', '');
    doGetCombo('/common/selectCodeList.do', '11', '', 'cmbCategory', 'S', '');
    // DSC CODE
    doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'DSCCodeList', 'M', 'fn_multiCombo'); //Branch Code

    doGetComboSepa('/common/selectCodeList.do', '452', ' - ', '', 'adptCode', 'M', 'fn_multiCombo'); //Branch Code

    createWaterEnvironmentListAUIGrid();
    //AUIGrid.setSelectionMode(myGridID, "singleRow");

    AUIGrid.bind(myGridID, "cellDoubleClick",
    function(event) {
    	// TODO - Display Order Details
        fn_setDetail(myGridID, event.rowIndex);
     });

    AUIGrid.bind(myGridID, "cellClick",
    function(event) {

    });
  });

  function fn_multiCombo() {
      $('#DSCCodeList').change(function() {
      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '100%'
      });
      $('#adptCode').change(function() {
      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '100%'
      });

    }

  function fn_waterEnvironmentListSearch() {
    Common.ajax("GET", "/services/waterEnvironmentListSearch.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  function fn_productList(selVal){
      if(!FormUtil.isEmpty(selVal)){
          $("#cmbProductList").attr({"disabled" : false  , "class" : "w100p"});

          var prodCatJson = {groupCode : selVal}; //Condition
          CommonCombo.make('cmbProductList', "/services/getProductListwithCategory.do", prodCatJson, '',{type: 'M'});
      }else{
          $('#cmbProductList').val('');
          $("#cmbProductList").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

      }
  }

  function fn_cityList(selVal){
      if(!FormUtil.isEmpty(selVal)){
          $("#resultCity").attr({"disabled" : false  , "class" : "w100p"});

          var resultStateJson = {state : selVal}; //Condition
          CommonCombo.make('resultCity', "/sales/customer/selectMagicAddressComboList", resultStateJson, '',{type: 'M'});
      }else{
          $('#resultCity').val('');
          $("#resultCity").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

      }
  }

  function fn_resultfailChildCode(selVal){
      if(!FormUtil.isEmpty(selVal)){
          $("#resultfailChildCode").attr({"disabled" : false  , "class" : "w100p"});

          var resultFailCodeJson = {groupCode : selVal}; //Condition
          CommonCombo.make('resultfailChildCode', "/services/selectFailChild.do", resultFailCodeJson, '',{type: 'M'});
      }else{
          $('#resultfailChildCode').val('');
          $("#resultfailChildCode").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

      }
  }


  var myGridID;
  function createWaterEnvironmentListAUIGrid() {
    var columnLayout = [ {
      dataField : "resultType",
      headerText : "Result Type",
      editable : false,
      width : 100
    }, {
        dataField : "salesOrdId",
        headerText : "Sales Order Id",
        editable : false,
        width : 100 ,
        visible : false
      }, {
      dataField : "salesOrdNo",
      headerText : "Sales Order No",
      editable : false,
      width : 100
    }, {
      dataField : "typeNo",
      headerText : "Type",
      editable : false,
      width : 100
    }, {
      dataField : "appType",
      headerText : "Application Type",
      editable : false,
      width : 100
    }, {
      dataField : "prodCat",
      headerText : "Product Category",
      editable : false,
      width : 100
    }, {
      dataField : "product",
      headerText : "Product",
      editable : false,
      width : 100
    }, {
      dataField : "serialNo",
      headerText : "Serial No",
      editable : false,
      width : 100
    }, {
      dataField : "sirimNo",
      headerText : "Sirim No",
      editable : false,
      width : 100
    },{
      dataField : "status",
      headerText : "Result Status",
      editable : false,
      width : 100
    }, {
      dataField : "resultNo",
      headerText : "Result No",
      editable : false,
      width : 100
    }, {
      dataField : "apptDt",
      headerText : "Appointment Date",
      editable : false,
      width : 100
    }, {
      dataField : "comDt",
      headerText : "Complete Date",
      editable : false,
      width : 100
    }, {
        dataField:"resultKeyDt",
        headerText: "Result Key In Date",
        editable : false,
        width: 100
    }, {
        dataField : "failType",
        headerText : "Fail Type",
        editable : false,
        width : 100
    }, {
        dataField : "failFeedback",
        headerText : "Fail Feedback",
        editable : false,
        width : 100
    }
      , {
       dataField : "volt",
      headerText : "Voltage",
      editable : false,
      width : 100
    }, {
      dataField : "psi",
      headerText : "Water Pressure (PSI)",
      width : 100
    }, {
      dataField : "lpm",
      headerText : "Water Flow Rate (LPM)",
      width : 100
    }, {
      dataField : "boostPump",
      headerText : "Booster Pump",
      width : 100
    }, {
      dataField : "afterPsi",
      headerText : "After Pump Water Pressure (PSI)",
      width : 100
    }, {
      dataField : "afterLpm",
      headerText : "After Pump Water Flow Rate (LPM)",
      width : 100
    }, {
      dataField : "tds",
      headerText : "Total Dissolved Solid (TDS)",
      width : 100
    }, {
      dataField : "ntu",
      headerText : "Nephelometric Turbidity Unit (NTU)",
      width : 100
    }, {
      dataField : "roomTemp",
      headerText : "Room Temperature",
      width : 100
    },{
        dataField : "waterSrcTemp",
        headerText : "Water Source Temp",
        width : 100
    },{
        dataField : "adptUsed",
        headerText : "Adapter Used",
        width : 100
    },{
        dataField : "sumTotalPic",
        headerText : "Count of Picture",
        width : 100
    },{
        dataField : "dscBrnchCode",
        headerText : "DSC",
        width : 100
    },{
        dataField : "ctCode",
        headerText : "CT Code",
        width : 100
    },{
        dataField : "ctName",
        headerText : "CT Name",
        width : 100
    },{
        dataField : "ctHpNo",
        headerText : "CT HP No",
        width : 100
    },{
        dataField : "custName",
        headerText : "Customer Name",
        width : 100
    },{
        dataField : "area",
        headerText : "Area",
        width : 100
    },{
        dataField : "city",
        headerText : "City",
        width : 100
    },{
        dataField : "postcode",
        headerText : "Postcode",
        width : 100
    },{
        dataField : "state",
        headerText : "State",
        width : 100
    },{
        dataField : "areaId",
        headerText : "Area ID",
        width : 100
    },{
        dataField : "waterSrcType",
        headerText : "Water Source",
        width : 100
    }
    ];

    var gridPros = {
      showRowCheckColumn : true,
      usePaging : true,
      pageRowCount : 20,
      showRowAllCheckBox : true,
      editable : false
    };

    myGridID = AUIGrid.create("#result_grid_wrap", columnLayout, gridPros);
  }

  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon
        .exportTo("result_grid_wrap", "csv",
            "WaterEnvironmentRaw");
  }

  $.fn.clearForm = function() {
	    return this.each(function() {
	      var type = this.type, tag = this.tagName.toLowerCase();
	      if (tag === 'form') {
	        return $(':input', this).clearForm();
	      }
	      if (type === 'text' || type === 'password' || type === 'hidden'
	          || tag === 'textarea') {
	        this.value = '';
	      } else if (type === 'checkbox' || type === 'radio') {
	        this.checked = false;
	      } else if (tag === 'select') {
	        this.selectedIndex = -1;
	      }
	    });
	  };

     function fn_waterEnvironmentListSearch(){

    	 if($("#resultType").val() == "" ){
    		  Common.alert("Please choose Result Type.");
              return;
    	 }


    	    if ($("#orderNo").val() == "") {
    	        if (($("#appointmentStartDate").val() == "" || $("#appointmentEndDate").val() == "") &&
    	        		($("#resultStartDate").val() == "" || $("#resultEndDate").val() == "") &&
    	        		($("#comStartDate").val() == "" || $("#comEndDate").val() == "")
    	        ) {
    	          Common.alert("Order No or either Appointment Date / Key In Date / Complete Date are compulsory option to search");
    	          return;
    	        }
    	      }


    	 Common.ajax("GET", "/services/waterEnvironmentListSearch.do", $("#searchForm").serialize(), function(result) {
    	        AUIGrid.setGridData(myGridID, result);
    	      });
     }

     function fn_setDetail(myGridID, rowIdx){
         //(_url, _jsonObj, _callback, _isManualClose, _divId, _initFunc)
         Common.popupDiv("/sales/order/orderDetailPop.do", { salesOrderId : AUIGrid.getCellValue(myGridID, rowIdx, "salesOrdId") }, null, true, "_divIdOrdDtl");
     }


</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>

 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>
  Water Environment
  </h2>
  <ul class="right_btns">

   <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue">
      <a href="#" onclick="javascript:fn_waterEnvironmentListSearch()"><span
       class="search"></span>
      <spring:message code='sys.btn.search' /></a>
     </p></li>
   </c:if>
   <li><p class="btn_blue">
      <a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>
     <spring:message code='sal.btn.clear' /></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id='reportFormWELst' method="post" name='reportFormWELst' action="#">
    <input type='hidden' id='reportFileName' name='reportFileName'/>
    <input type='hidden' id='viewType' name='viewType'/>
    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
    <input type='hidden' id='V_TEMP' name='V_TEMP'/>
  </form>

  <form action="#" method="post" id="searchForm">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 170px" />
     <col style="width: *" />
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 230px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Result Type<span class="must">*</span></th>
    <td>
        <!-- <select id="resultType" name="resultType" class="multy_select w100p" multiple="multiple" > -->
        <select id="resultType" name="resultType" class="w100p" >
        <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
               <option value="INS">Installation</option>
               <option value="AS">After Service</option>
        </select>
    </td>
    <th scope="row"><spring:message code='service.title.OrderNo' /></th>
      <td>
      <input type="text" class="w100p" title="Order No." placeholder="Order No." id="orderNo" name="orderNo" />
       </td>
      <th scope="row">Result No</th>
      <td><input type="text" class="w100p" title="Result No." placeholder="Result No." id="resultNo" name="resultNo" />
      </td>
    </tr>
    <tr>
      <th scope="row"><spring:message code='service.title.Type' /></th>
      <td><select class="multy_select w100p" id="typeCode" name="typeCode" multiple="multiple" >
        <option value="NEW">New Installation Order</option>
        <option value="PEX">Product Exchange</option>
        <option value="MAS">Manual AS</option>
        <option value="AAS">Auto AS</option>
      </select></td>

       <th scope="row">Result Status</th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="resultStatus" name="resultStatus">
        <c:forEach var="list" items="${resultStatus }"
         varStatus="status">
         <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>

       <th scope="row">Result Key In Date<span class="must">*</span></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="resultStartDate"
          name="resultStartDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="resultEndDate"
          name="resultEndDate" />
        </p>
       </div>
       <!-- date_set end -->
      </td>
    </tr>
    <tr>
    <th scope="row"><spring:message
        code='service.title.ApplicationType' /></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="resultAppType" name="appType">
        <c:forEach var="list" items="${resultAppTypeList}" varStatus="status">
         <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
      </select></td>

  <th scope="row"><spring:message
        code='service.title.AppointmentDate' /><span class="must">*</span></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="appointmentStartDate"
          name="appointmentStartDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="appointmentEndDate"
          name="appointmentEndDate" />
        </p>
       </div>
       <!-- date_set end -->
      </td>

      <th scope="row">Complete / Settle Date<span class="must">*</span></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date" id="comStartDate"
          name="comStartDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date" id="comEndDate"
          name="comEndDate" />
        </p>
       </div>
       <!-- date_set end -->
      </td>

    </tr>
    <tr>
     <th scope="row">Fail Type</th>
            <td>
              <select class="w100p" id="resultfailLocCde" name="resultfailLocCde" onchange = "javascript : fn_resultfailChildCode(this.value)">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failParent}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
            </td>
            </select>
            <th scope="row">Fail Feedback Code</th>
<%--             <td>
              <select class="w100p" id="resultfailChildCode" name="resultfailChildCode">
                <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${failChild}" varStatus="status">
                  <option value="${list.defectId}">${list.defectDesc}</option>
                </c:forEach>
              </select>
            </td> --%>

             <td><select class="w100p disabled" id="resultfailChildCode" name="resultfailChildCode" disabled>
      </select></td>

      <th scope="row"><spring:message code='service.title.SIRIMNo' /></th>
      <td><input type="text" class="w100p" title="SIRIM No." placeholder="SIRIM No."
       id="sirimNo" name="sirimNo" /></td>


    </tr>
    <tr>
     <th scope="row"><spring:message code='service.title.State' /></th>
      <td><select class="w100p" id="resultState" name="resultState" onchange = "javascript : fn_cityList(this.value)">
      </select></td>
      <th scope="row"><spring:message code="sys.city" /></th>
      <td><select class="w100p disabled" id="resultCity" name="resultCity" disabled>
      </select></td>
        <th scope="row"><spring:message code='service.title.SerialNo' /></th>
      <td><input type="text" class="w100p" title="Serial No."
       placeholder="Serial No." id="serialNo" name="serialNo" /></td>
    </tr>
    <tr>
       <th scope="row">Product Category</th>
         <td><select class="w100p" id="cmbCategory" name="cmbCategory" onchange = "javascript : fn_productList(this.value)"></select>
          </td>
           <th scope="row">Product</th>
        <%--  <td><select class="w100p" id="cmbProductList" name="cmbProductList" >
          <option value="" selected><spring:message code='sal.combo.text.chooseOne' /></option>
                <c:forEach var="list" items="${productList}" varStatus="status">
                  <option value="${list.code}">${list.codeName}</option>
                </c:forEach>
         </select>
          </td> --%>

            <td><select class="w100p disabled" id=cmbProductList  name="cmbProductList" disabled ></select></td>

      <th scope="row">CT Code</th>
      <td><input type="text" class="w100p" title="CT Code" placeholder="CT Code"
       id="ctCode" name="ctCode" /></td>

</tr>


<tr>
      <th scope="row"><spring:message code='service.title.DSCCode' /></th>
      <td><select class="multy_select w100p" multiple="multiple" id="DSCCodeList"
       name="DSCCodeList">
      </select></td>

      <th scope="row">Customer HP Number</th>
      <td><input type="text" class="w100p" title="Customer HP No." placeholder="Customer HP No." id="custHpNo" name="custHpNo" />
      </td>

    <th scope="row">Adaptor Used</th>
    <td><select class="multy_select w100p" multiple="multiple" id="adptCode"
       name="adptCode">
      </select></td>

</tr>

<tr>
<th scope="row">Voltage</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="voltageFrom"
          name="voltageFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="voltageTo"
          name="voltageTo" />
        </p>
        </div>
      </td>

      <th scope="row">Water Pressure (PSI)</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="psiFrom"
          name="psiFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="psiTo"
          name="psiTo" />
        </p>
        </div>
      </td>

            <th scope="row">Water Flow Rate (LPM)</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="lpmFrom"
          name="lpmFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="lpmTo"
          name="lpmTo" />
        </p>
        </div>
      </td>
</tr>
<tr>
           <th scope="row">Total Dissolved Solid (TDS)</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="tdsFrom"
          name="tdsFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="tdsTo"
          name="tdsTo" />
        </p>
        </div>
      </td>

                 <th scope="row">Room Temperature </th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="roomTempFrom"
          name="roomTempFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="roomTempTo"
          name="roomTempTo" />
        </p>
        </div>
      </td>

                       <th scope="row">Water Source Temp </th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="waterSrcTempFrom"
          name="waterSrcTempFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="waterSrcTempTo"
          name="waterSrcTempTo" />
        </p>
        </div>
      </td>


</tr>
<tr>
                  <th scope="row">After Pump Water Pressure (PSI)</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="afterPsiFrom"
          name="afterPsiFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="afterPsiTo"
          name="afterPsiTo" />
        </p>
        </div>
      </td>

                  <th scope="row">After Pump Water Flow Rate (LPM)</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="afterLpmFrom"
          name="afterLpmFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="afterLpmTo"
          name="afterLpmTo" />
        </p>
        </div>
      </td>

  <th scope="row">Area</th>
      <td>
      <input type="text" class="w100p" title="resultArea" placeholder="resultArea" id="resultArea" name="resultArea" />
       </td>

</tr>
<tr>
  <th scope="row">Nephelometric Turbidity Units (NTU)</th>
      <td>
        <div class="date_set w100p">
        <p>
         <input type="text" title="From"
          placeholder="From" class="w100p"  id="ntuFrom"
          name="ntuFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="To"
          placeholder="To" class="w100p" id="ntuTo"
          name="ntuTo" />
        </p>
        </div>
      </td>
      <th>
      </th>
      <td></td>
      <th></th>
      <td></td>
</tr>

    </tbody>
   </table>
   <!-- table end -->

   <br/>
   <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message
         code='service.btn.Generate' /></a>
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
    <div id="result_grid_wrap"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->
