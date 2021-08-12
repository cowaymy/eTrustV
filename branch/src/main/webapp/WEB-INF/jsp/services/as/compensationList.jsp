<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
.my_left_style {
  text-align: left;
}
</style>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 01/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP
 18/06/2019  ONGHC  1.0.1          AMENMENT BASED ON USER REQEST
 -->

<script type="text/javaScript">
  var option = {
    width : "1200px",
    height : "500px"
  };

  var myGridID;
  var cpsNo;

  function fn_searchASManagement() {
    Common.ajax("GET", "/services/compensation/selCompensation.do", $("#compensationForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }

  $(document).ready(
    function() {
      doGetComboAndGroup2('/common/selectProductCodeList.do', '', '', 'prodId', 'S', 'fn_setOptGrpClass');//product 생성

      cpsGrid();
      //AUIGrid.setSelectionMode(myGridID, "singleRow");
      AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        Common.popupDiv("/services/compensation/compensationViewPop.do?cpsNo=" + cpsNo, null, null, true, '_compensationViewPop');
      });

      AUIGrid.bind(myGridID, "cellClick", function(event) {
        cpsNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "cpsNo");
      });
    });

  function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text");
  }

  function cpsGrid() {
    var columnLayout = [ {
      dataField : "issueDt",
      headerText : "<spring:message code='service.text.IssueDt'/>",
      editable : false,
      width : 150
    }, {
        dataField : "asRqstDt",
        headerText : "<spring:message code='service.text.AsRqstDt'/>",
        editable : false,
        width : 150
    }, {
      dataField : "ordNo",
      headerText : "<spring:message code='service.grid.SalesOrder'/>",
      editable : false,
      width : 150
    }, {
      dataField : "cusId",
      headerText : "<spring:message code='service.grid.CustomerId'/>",
      editable : false,
      width : 100
    }, {
      dataField : "cusNm",
      headerText : "<spring:message code='service.grid.CustomerName'/>",
      editable : false,
      width : 200
    }, {
      dataField : "stkDesc",
      headerText : "<spring:message code='service.grid.Product'/>",
      editable : false,
      width : 200
    }, {
      dataField : "stkCde",
      headerText : "<spring:message code='service.grid.Product'/>",
      editable : false,
      width : 200,
      visible : false
    }, {
      dataField : "brchCde",
      headerText : "<spring:message code='service.grid.Branch'/>",
      editable : false,
      width : 200,
      style : "my-column"
    }, {
      dataField : "cspTypId",
      headerText : "<spring:message code='service.grid.CpsTyp'/>",
      editable : false,
      width : 200,
      style : "my-column",
    }, {
      dataField : "deptToBear",
      headerText : "<spring:message code='service.grid.RespTyp'/>",
      editable : false,
      width : 200,
      style : "my-column",
    }, {
      dataField : "cspMlfncRsnId",
      headerText : "<spring:message code='service.grid.Cause'/>",
      editable : false,
      style : "my-column",
      width : 200
    }, {
      dataField : "cspPftTypId",
      headerText : "<spring:message code='service.grid.EvtTyp'/>",
      editable : false,
      style : "my-column",
      width : 200
   } , {
      dataField : "compDt",
      headerText : "<spring:message code='service.grid.CompDt'/>",
      width : 120
    }, {
      dataField : "cspAmt",
      headerText : "<spring:message code='service.grid.Rm'/>",
      dataType : "numeric",
      width : 100
    }, {
      dataField : "stusCodeId",
      headerText : "<spring:message code='service.grid.Status'/>",
      width : 100
    }, {
      dataField : "stusId",
      headerText : "stusId",
      width : 100,
      visible : false
    }, {
      dataField : "crtDt",
      headerText : "<spring:message code='service.grid.CrtDt'/>",
      width : 100
    }, {
      dataField : "crtUserId",
      headerText : "<spring:message code='service.grid.CrtBy'/>",
      width : 100
    }, {
      dataField : "updDt",
      headerText : "<spring:message code='service.title.UpdateDate'/>",
      width : 100
    }, {
      dataField : "updUserId",
      headerText : "<spring:message code='service.grid.UpdateBy'/>",
      width : 100
    }, {
      dataField : "cpsNo",
      headerText : "cpsNo",
      width : 100,
      visible : false
    }, {
      dataField : "rcdTms",
      headerText : "rcdTms",
      width : 100,
      visible : false
    } ];

    var gridPros = {
      usePaging : true,
      headerHeight : 30,
      pageRowCount : 20,
      editable : false//,
      //selectionMode : "singleRow"
    };

    myGridID = AUIGrid.create("#grid_wrap_compensation", columnLayout, gridPros);
  }

  var gridPros = {
    usePaging : true,
    pageRowCount : 20,
    editable : true,
    fixedColumnCount : 1,
    showStateColumn : true,
    displayTreeOpen : true,
    //selectionMode : "singleRow",
    headerHeight : 30,
    useGroupingPanel : true,
    skipReadonlyColumns : true,
    wrapSelectionMove : true,
    showRowNumColumn : false,
    noDataMessage : gridMsg["sys.info.grid.noDataMessage"]
  };

  function fn_addCompPop() {
    Common.popupDiv("/services/compensation/compensationOrdSearchPop.do", null, null, true, '_NewEntryPopDiv1');
    //Common.popupDiv("/services/compensation/compensationAddPop.do", null, null, true, '');
  }

  function fn_compPop(ordNo, ordId) {
    var prm = "?ordNo=" + ordNo + "&ordId=" + ordId + " ";

    Common.popupDiv("/services/compensation/compensationAddPop.do" + prm, null, null, true, '_resultNewEntryPopDiv1');
  }

  function fn_editCompPop(ind) {
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.selectRcd'/> ");
      return;
    }

    if (ind == 0) {
      if (selectedItems[0].item.stusId == "10" || selectedItems[0].item.stusId == "34" || selectedItems[0].item.stusId == "36") {
        Common.alert("<spring:message code='service.msg.CpsEdtStatChk'/>" );
        return;
      }
    }

    Common.popupDiv("/services/compensation/compensationEditPop.do?cpsNo=" + cpsNo, null, null, true, '_compensationEditPop');
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
        this.selectedIndex = 0;
      }
    });
  };

  function fn_excelDown() {
    GridCommon.exportTo("grid_wrap_compensation", "xlsx", "Compensation Listing");
  }

  function fn_genAcptLetter() {
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.selectRcd'/> ");
      return;
    }

    //if (selectedItems[0].item.stusId == "1") {
      //Common.alert("<spring:message code='service.msg.CpsGenAcptLetterChk'/>" );
      //return;
    //}

    var cpsNo = selectedItems[0].item.cpsNo;
    var ordNo = selectedItems[0].item.ordNo;

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    $("#reportForm #reportFileName").val('/services/CpsAcptLetter.rpt');
    $("#reportForm #reportDownFileName").val("CpsAcptLetter_" + day + month + date.getFullYear() + "_" + ordNo);
    $("#reportForm #viewType").val("PDF");
    $("#reportForm #cpsNo").val(cpsNo);

    var option = {
      isProcedure : true,
    };

    Common.report("reportForm", option);
  }

</script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <!-- <h2>Compensation Log Search</h2> -->
  <h2>
   <spring:message code='service.title.Compensation' />
  </h2>
  <ul class="right_btns">
   <!-- 171110 :: 선한이  -->
   <li><p class="btn_blue">
     <c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <a href="#" onClick="javascript:fn_searchASManagement()"><span
       class="search"></span> <spring:message code="expense.btn.Search" /></a>
     </c:if>
    </p></li>
   <li><p class="btn_blue">
     <a href="#"
      onclick="javascript:$('#compensationForm').clearForm();"><span
      class="clear"></span><spring:message code="service.btn.Clear" /></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form action="#" method="post" id="compensationForm" name="compensationForm">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 140px" />
     <col style="width: *" />
     <col style="width: 170px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='service.grid.SalesOrder'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.grid.SalesOrder'/>"
       class="w100p" id="orderNum" name="orderNum" /></td>

      <th scope="row"><spring:message code='service.grid.CustomerId'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.grid.CustomerId'/>"
       class="w100p" id="customerCode" name="customerCode" /></td>

      <th scope="row"><spring:message code='service.title.CustomerName'/></th>
      <td><input type="text" title="" placeholder="<spring:message code='service.title.CustomerName'/>"
       class="w100p" id="customerNm" name="customerNm" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.grid.Product'/></th>
      <td>
        <select id="prodId" name="prodId" class="w100p"></select>
      </td>
      <th scope="row"><spring:message code='service.text.IssueDt'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date"
          id="applicationStrDate" name="applicationStrDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date"
          id="applicationEndDate" name="applicationEndDate" />
        </p>
       </div> <!-- date_set end -->
      </td>
      <th scope="row"><spring:message code='service.grid.CompDt'/></th>
      <td>
       <div class="date_set w100p">
        <!-- date_set start -->
        <p>
         <input type="text" title="Create start Date"
          placeholder="DD/MM/YYYY" class="j_date"
          id="compStrDate" name="compStrDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date"
          placeholder="DD/MM/YYYY" class="j_date"
          id="compEndDate" name="compEndDate" />
        </p>
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
     <th scope="row"><spring:message code='service.grid.Branch'/></th>
      <td>
       <select id="brchCde" name="brchCde" class="w100p"
       placeholder="<spring:message code='service.grid.Branch'/>">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${branchWithNMList}"
         varStatus="status">
         <option value="${list.codeId}">${list.codeName }</option>
        </c:forEach>
      </select>
     </td>
     <th scope="row"><spring:message code='service.grid.CpsTyp'/></th>
      <td><select class="w100p" id="cpsTyp" name="cpsTyp">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${cpsTyp}"
         varStatus="cpsTyp">
         <option value="${list.codeId}">${list.codeName }</option>
        </c:forEach>
      </select>
      </td>
      <th scope="row"><spring:message code='service.grid.RespTyp'/></th>
      <td><select class="w100p" id="respTyp" name="respTyp">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
         <c:forEach var="list" items="${mainDeptList}"
            varStatus="status">
            <option value="${list.codeId}">${list.codeName }</option>
         </c:forEach>
      </select>
      </td>
     </tr>
     <tr>
       <th scope="row"><spring:message code='service.grid.Cause'/></th>
      <td><select class="w100p" id="cause" name="cause">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${cpsCocTyp}"
         varStatus="cause">
         <option value="${list.codeId}">${list.codeName }</option>
        </c:forEach>
      </select>
      </td>
      <th scope="row"><spring:message code='service.grid.EvtTyp'/></th>
      <td><select class="w100p" id="evtTyp" name="evtTyp">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${cpsEvtTyp}"
         varStatus="evtTyp">
         <option value="${list.codeId}">${list.codeName }</option>
        </c:forEach>
      </select>
      </td>
      <th scope="row"><spring:message code='service.grid.Status'/></th>
      <td><select class="w100p" id="status" name="status">
        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
        <c:forEach var="list" items="${cpsStatus}"
         varStatus="status">
         <option value="${list.codeId}">${list.codeName }</option>
        </c:forEach>
      </select>
      </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <ul class="right_btns">
    <li><p class="btn_grid">
       <a href="#" onClick="fn_genAcptLetter()"><spring:message code='service.btn.AcptLetter'/></a>
     </p></li>
    <li><p class="btn_grid">
       <a href="#" onClick="fn_addCompPop()"><spring:message code='service.btn.AddCase'/></a>
     </p></li>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'N'}">
    <li><p class="btn_grid">
       <a href="#" onClick="fn_editCompPop(0)"><spring:message code='service.btn.EditCase'/></a>
     </p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid">
       <a href="#" onClick="fn_editCompPop(1)"><spring:message code='service.btn.EditCase'/></a>
     </p></li>
    </c:if>
    <li><p class="btn_grid">
       <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a>
     </p></li>
   </ul>
   <article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_compensation"
     style="width: 100%; height: 500px; margin: 0 auto;"></div>
   </article>
   <!-- grid_wrap end -->
  </form>
  <form action="#" id="reportForm" method="post">
   <input type="hidden" id="reportFileName" name="reportFileName" />
   <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
   <input type="hidden" id="viewType" name="viewType" />
   <input type="hidden" id="cpsNo" name="cpsNo" />
  </form>
 </section>
 <!-- search_table end -->
</section>
<!-- content end -->
