<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid 생성 후 반환 ID
  var myGridID;
  var basicAuth = false;
  var rcdTms;
  var brnchType = 0;
  var isHomecareUser = "${SESSION_INFO.roleId}" == "297" ? true : false;
  $(document).ready(
      function() {
    	  if (isHomecareUser) {
    		  $("#isHomecare").val("1");
    		  brnchType = 5758;
    	  }else if ("${SESSION_INFO.memberLevel}" == "" && '${SESSION_INFO.roleId}' != 130){
    		  $("#isHomecare").val("2");
    		  brnchType = 3;
    	  }

    	  if ("${SESSION_INFO.memberLevel}" == "1") {

              $("#orgCode").val("${orgCode}");
              $("#orgCode").attr("class", "w100p readonly");
              $("#orgCode").attr("readonly", "readonly");

         } else if ("${SESSION_INFO.memberLevel}" == "2") {

              $("#orgCode").val("${orgCode}");
              $("#orgCode").attr("class", "w100p readonly");
              $("#orgCode").attr("readonly", "readonly");

              $("#grpCode").val("${grpCode}");
              $("#grpCode").attr("class", "w100p readonly");
              $("#grpCode").attr("readonly", "readonly");

          } else if ("${SESSION_INFO.memberLevel}" == "3") {

              $("#orgCode").val("${orgCode}");
              $("#orgCode").attr("class", "w100p readonly");
              $("#orgCode").attr("readonly", "readonly");

              $("#grpCode").val("${grpCode}");
              $("#grpCode").attr("class", "w100p readonly");
              $("#grpCode").attr("readonly", "readonly");

              $("#deptCode").val("${deptCode}");
              $("#deptCode").attr("class", "w100p readonly");
              $("#deptCode").attr("readonly", "readonly");

          } else if ("${SESSION_INFO.memberLevel}" == "4") {

              $("#orgCode").val("${orgCode}");
              $("#orgCode").attr("class", "w100p readonly");
              $("#orgCode").attr("readonly", "readonly");

              $("#grpCode").val("${grpCode}");
              $("#grpCode").attr("class", "w100p readonly");
              $("#grpCode").attr("readonly", "readonly");

              $("#deptCode").val("${deptCode}");
              $("#deptCode").attr("class", "w100p readonly");
              $("#deptCode").attr("readonly", "readonly");
          }

        createAUIGrid();

        doGetComboSepa('/common/selectBranchCodeList.do', brnchType , ' - ', '${SESSION_INFO.userBranchId}', 'cmbDscBranchId', 'M', 'f_multiCombo'); //Branch Code

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        	if (event.item.appType == 'Auxiliary') {
                Common.alert('<spring:message code="sal.alert.msg.actionRestriction" />' + DEFAULT_DELIMITER + "<b>Auxiliary type is not allowed to do eRequest approval.</b>");
            } else {
                	$("#rqstId").val(event.item.rqstId);
                	$("#salesOrderId").val(event.item.salesOrdId);
                	$("#typeId").val(event.item.typeId);
                  Common.popupDiv("/sales/order/eRequestApprovalPop.do", $("#detailForm").serializeJSON());
            }
        });
      });

  function createAUIGrid() {

    var columnLayout = [
        { dataField : "rqstId", headerText : "Request ID", width : '5%', editable : false , visible : false}
        , { dataField : "salesOrdId", headerText : "Sales Order ID", width : '5%', editable : false , visible : false}
        , { dataField : "salesOrdNo", headerText : "<spring:message code='sal.title.ordNo' />", width : '5%', editable : false }
        , { dataField : "stus", headerText : "<spring:message code='sal.title.text.requestStatus' />",width : '5%', editable : false }
        , { dataField : "appType", headerText : "<spring:message code='sal.title.text.appType' />", width : '5%', editable : false }
        , { dataField : "custName", headerText : "<spring:message code='sal.title.text.customer' />", width : '10%' ,editable : false }
        , { dataField : "nric", headerText : "<spring:message code='sal.title.text.nricCompNo' />", width : '10%', editable : false }
        , { dataField : "instStus", headerText : "<spring:message code='sal.title.text.requestStage' />", width : '7%', editable : false }
        , { dataField : "rqstType", headerText : "<spring:message code='log.label.rqstTyp' />",width : '7%', editable : false }
        , { dataField : "rqstRem", headerText : "<spring:message code='sal.title.text.reqstRem' />", editable : false}
        , { dataField : "crtUser", headerText : "<spring:message code='sal.title.created' />",width : '7%',editable : false }
        , { dataField : "crtDt", headerText : "<spring:message code='sal.title.crtDate' />",width : '7%',editable : false }
        , { dataField : "updUser", headerText : "<spring:message code='sal.title.updateBy' />",width : '7%',editable : false }
        , { dataField : "updDt", headerText : "<spring:message code='sal.title.updateDate' />",width : '7%',editable : false }
        , { dataField : "rem", headerText : "<spring:message code='sal.title.remark' />", editable : false}
        , { dataField : 'dsc', headerText : 'DSC', width : 100, editable : false }
        , { dataField : 'rqstDataFr', headerText : 'Request Data From', width : 100, visible : false, editable : false }
        , { dataField : 'rqstDataTo', headerText : 'Request Data To', width : 100, visible : false, editable : false }
    ];

    // 그리드 속성 설정
    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      fixedColumnCount : 1,
      wordWrap : true
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
  }

  // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
  doGetCombo('/common/selectCodeList.do', '10', '', 'cmbAppTypeId', 'M','f_multiCombo'); // Application Type Combo Box

  // 조회조건 combo box
  function f_multiCombo() {
    $(function() {
      $('#cmbAppTypeId').change(function() {

      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '80%'
      });
      $('#cmbAppTypeId').multipleSelect("checkAll");

      $('#cmbDscBranchId').change(function() {
      }).multipleSelect({
        selectAll : true,
        width : '100%'
      });
      $("#cmbDscBranchId").multipleSelect("disable");

      if(isHomecareUser){
    	  $('#cmbDscBranchId').multipleSelect("checkAll");
      }
    });
  }

  // 리스트 조회.
  function fn_requestApprovalListAjax() {
    Common.ajax("GET", "/sales/order/selectRequestApprovalList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
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
        this.text = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
        this.text = '';
      } else if (tag === 'select') {
        this.selectedIndex = -1;
        this.text = '';
      }
    });
  };
 </script>
<section id="content">
 <!-- content start -->
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
  <li>Sales</li>
  <li>eRequest</li>
  <li>eRequest Approval</li>
 </ul>
 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>
   <spring:message code="sales.title.eReqAppr" />
  </h2>
  <ul class="right_btns">
   <%-- <c:if test="${PAGE_AUTH.funcView == 'Y'}"> --%>
    <li><p class="btn_blue">
      <a href="#" onclick="javascript:fn_requestApprovalListAjax()"><span
       class="search"></span>
      <spring:message code="sal.btn.search" /></a>
     </p></li>
   <%-- </c:if> --%>
   <li><p class="btn_blue">
     <a href="#" onclick="javascript:$('#searchForm').clearForm();"><span
      class="clear"></span>
     <spring:message code="sal.btn.clear" /></a>
    </p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <section class="search_table">
  <!-- search_table start -->
  <form id="detailForm" name="detailForm" method="post">
   <input type="hidden" id="rqstId" name="rqstId">
   <input type="hidden" id="salesOrderId" name="salesOrderId">
   <input type="hidden" id="typeId" name="typeId">

  </form>
  <form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="isHomecare" name="isHomecare">
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
      <th scope="row"><spring:message code="sal.text.ordNo" /></th>
        <td><input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" /></td>
      <th scope="row"><spring:message code="sal.text.appType" /></th>
        <td><select id="cmbAppTypeId" name="cmbAppTypeId" class="multy_select w100p" multiple="multiple">
      </select></td>
      <th scope="row"><spring:message code="sal.text.requestDate" /></th>
        <td>
        <div class="date_set w100p">
            <p><input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span><spring:message code="sal.text.to" /></span>
            <p><input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
       </div>
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
        <select id="cmbDscBranchId" name="cmbDscBranchId"class="multy_select w100p" multiple="multiple"></select>
      </td>
      <th scope="row"><spring:message code="sal.text.creator" /></th>
        <td><input type="text" title="" id="crtUserId" name="crtUserId" placeholder="Creator(UserName)" class="w100p" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code="sal.text.customerId" /></th>
        <td><input type="text" title="" id="custId" name="custId" placeholder="Customer ID(Number Only)" class="w100p" /></td>
      <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td><input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" /></td>
      <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
        <td><input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" /></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code="sal.title.text.requestStatus" /></th>
        <td>
            <select id="reqStusId" name="reqStusId" class="multy_select w100p" multiple="multiple">
                <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
                <option value="5" selected><spring:message code="sal.combo.text.approv" /></option>
                <option value="6" selected><spring:message code="sal.combo.text.rej" /></option>
            </select>
        </td>
      <th scope="row"></th>
        <td></td>
      <th scope="row"></th>
        <td></td>
     </tr>
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
    </tbody>
   </table>
   <!-- table end -->

  </form>
 </section>
 <!-- search_table end -->
 <section class="search_result">
  <!-- search_result start -->
  <article class="grid_wrap">
   <!-- grid_wrap start -->
   <div id="grid_wrap"
    style="width: 100%; height: 480px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->