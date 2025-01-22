<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
  <%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">
  .aui-grid-left-column {
    text-align: left;
  }

  .write-active-style {
    background: #ddedde;
  }

  .my-inactive-style {
    background: #efcefc;
  }
</style>

<script type="text/javaScript">
  var prodCatList = new Array();
  var statusList = new Array();
  var largeGridID;
  var oldRowIndex = -1;

  $(document).ready(function(){
    createLargeAUIGrid();
    //getProdCat();
    //getStatus();

    AUIGrid.bind(largeGridID, "cellDoubleClick", function(event) {
      var selectedItems = AUIGrid.getSelectedItems(largeGridID);
      var viewType = 3; // View

      var defectId = selectedItems[0].item.defectId;
      var prodCat = selectedItems[0].item.prodCat == '-' && selectedItems[0].item.prodCat == '*' ? null : selectedItems[0].item.prodCat;
      var stusId = selectedItems[0].item.stusId;
      var defCode = selectedItems[0].item.defectCode;

      Common.popupDiv("/services/svcCodeConfig/addEditSvcCodeConfigPop.do?isPop=true&defectId=" + defectId + "&viewType=" + viewType + "&defCode=" + defCode
                + "&prodCat=" + prodCat + "&stusId=" + stusId);
    });
  });

  function fn_selectSvcCodeConfigList() {
    AUIGrid.refreshRows() ;

    if ($("#prodCode").val() == '' && $("#defName").val() == '' && $("#defCode").val() == '') {
      if ($("#cmbCodeCat").val() == null) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Code Category' htmlEscape='false'/>");
        return false;
      }
    }

    Common.ajax("GET", "/services/svcCodeConfig/selectSvcCodeConfigList.do", $("#MainForm").serialize() , function(result){
      AUIGrid.setGridData(largeGridID, result);
      oldRowIndex = -1;
    });
  }

  function createLargeAUIGrid() {
    var options = {
      usePaging : true,
      pageRowCount: 20,
      editable: false,
      // fixedColumnCount : 1,
      headerHeight : 30,
      showRowNumColumn : true
    };

    var MainColumnLayout = [ { dataField : "prodCat",
                                             headerText : "Product Category",
                                             width : "10%"
                                          }, {
                                            dataField : "defectGrp",
                                            headerText : "DefectGrp",
                                            width : "5%",
                                            visible: false
                                          }, {
                                            dataField : "defectGrpCode",
                                            headerText : "DefectGrp",
                                            width : "5%",
                                            visible: false
                                          }, {
                                            dataField : "defectId",
                                            headerText : "DefectId",
                                            width : "5%",
                                            visible: false
                                         }, {
                                            dataField : "defectTyp",
                                            headerText : "Defect Type",
                                            width : "10%"
                                         }, {
                                            dataField : "defectCode",
                                            headerText : "Defect Code",
                                            width : "10%"
                                         }, {
                                            dataField : "defectDesc",
                                            headerText : "Defect Description",
                                            width : "25%"
                                         }, {
                                            dataField : "defectRemark",
                                            headerText : "Remark",
                                            width : "25%"
                                         }, {
                                            dataField : "stusId",
                                            headerText : "stusId",
                                            width : "5%",
                                            visible: false
                                         }, {
                                            dataField : "status",
                                            headerText : "Status",
                                            width : "10%"
                                         }, {
                                            dataField : "effDt",
                                            headerText : "Effective Date",
                                            dataType : "date",
                                            formatString : "dd-mm-yyyy",
                                            width : "10%"
                                         }, {
                                            dataField : "expDt",
                                            headerText : "Expire Date",
                                            dataType : "date",
                                            formatString : "dd-mm-yyyy",
                                            width : "10%"
                                         }, {
                                            dataField : "crtUser",
                                            headerText : "Create By",
                                            width : "10%"
                                         }, {
                                            dataField : "crtDt",
                                            headerText : "Create Date",
                                            dataType : "date",
                                            formatString : "dd-mm-yyyy",
                                            width : "10%"
                                         }, {
                                            dataField : "updUser",
                                            headerText : "Update By",
                                            width : "10%"
                                         }, {
                                            dataField : "updDt",
                                            headerText : "Update Date",
                                            dataType : "date",
                                            formatString : "dd-mm-yyyy",
                                            width : "10%"
                                         }];

    largeGridID = GridCommon.createAUIGrid("largeGrid", MainColumnLayout,"", options);
  }

  function f_multiCombo(){
    $(function() {
        $('#cmbProductCtgry').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '80%'
        });
    });
  }

  function fn_clear(){
    $("#cmbProductCtgry").multipleSelect("uncheckAll");
    $("#codeStatus").multipleSelect("uncheckAll");
    $("#defCode").val("");
    $("#prodCode").val("");
    $("#defName").val("");
    AUIGrid.clearGridData(largeGridID);
  }

  function getProdCat(callBack) {
    Common.ajaxSync("GET", "/services/svcCodeConfig/selectProductCategoryList.do" , "" , function(result){
      prodCatList.push({id:"" ,value:""});
      for (var i = 0; i < result.length; i++){
        var list = new Object();
        list.id = result[i].code;
        list.value = result[i].codeName ;
        prodCatList.push(list);
      }

      if (callBack) {
        callBack(prodCatList);
      }
    });

    return prodCatList;
  }

  function getStatus(callBack) {
    Common.ajaxSync("GET", "/services/svcCodeConfig/selectStatusCategoryCodeList.do" , "" , function(result){
      statusList.push({id:"" ,value:""});
      for (var i = 0; i < result.length; i++){
        var list = new Object();
        list.id = result[i].code;
        list.value = result[i].codeName ;
        statusList.push(list);
      }

      if (callBack) {
        callBack(statusList);
      }
   });

    return statusList;
  }

  function fn_addEditSvcCodeConfigPop(viewType) {
    if (viewType == 1) {
      Common.popupDiv("/services/svcCodeConfig/addEditSvcCodeConfigPop.do?isPop=true&viewType=" + viewType, "", null, "false", "addSvcCodeConfigPopupId");
    } else { // 2 OR 3 == edit OR VIEW
      fn_editCode(viewType);
    }
  }

  function fn_editCode(viewType){
    var selectedItems = AUIGrid.getSelectedItems(largeGridID);

    if (selectedItems.length <= 0) {
      Common.alert("<spring:message code='service.msg.NoRcd'/> ");
      return;
    }

    var defectId = selectedItems[0].item.defectId;
    var prodCat = selectedItems[0].item.prodCat == '-' && selectedItems[0].item.prodCat == '*' ? null : selectedItems[0].item.prodCat;
    var stusId = selectedItems[0].item.stusId;
    var defCode = selectedItems[0].item.defectCode;
    var defDesc = selectedItems[0].item.defectDesc;

    Common.popupDiv("/services/svcCodeConfig/addEditSvcCodeConfigPop.do?isPop=true&defectId=" + defectId + "&viewType=" + viewType + "&defCode=" + defCode
            + "&stusId=" + stusId + "&defDesc=" + defDesc + "&prodCat=" + prodCat
            , "", null, "false", "addSvcCodeConfigPopupId");
  }

  function fn_excelDown() {
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();

    GridCommon.exportTo("largeGrid", "xlsx", "Service Code Configuration List" + yyyy + mm + dd);
  }
</script>

<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="svc.title.svcCodeConfig" /></li>
  </ul>

  <aside class="title_line">
    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2><spring:message code="svc.title.svcCodeConfig" /></h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
          <li><p class="btn_blue"><a id="btnNew" href="#" onclick="javascript:fn_addEditSvcCodeConfigPop(1)"><spring:message code="sys.btn.new"/></a></p></li>
          <li><p class="btn_blue"><a id="btnEdit" href="#" onclick="javascript:fn_addEditSvcCodeConfigPop(2)"><spring:message code="sys.btn.edit"/></a></p></li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
          <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectSvcCodeConfigList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
      </c:if>
    </ul>
  </aside>

  <section class="search_table">
    <form id="MainForm" method="get" action="">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width:100px" />
          <col style="width:100px" />
          <col style="width:100px" />
          <col style="width:100px" />
          <col style="width:100px" />
          <col style="width:100px" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="svc.title.text.productCategory" /></th>
            <td>
              <select class="multy_select w100p" multiple="multiple" id="productCtgry" name="productCtgry">
                <c:forEach var="list" items="${prodCatList}" varStatus="status">
                  <option value="${list.code}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="service.text.dftCde" /></th>
            <td>
                <input type=text name="defCode" id="defCode" class="w100p" value=""/>
            </td>
            <th scope="row"><spring:message code="service.title.Status"/></th>
            <td>
              <select class="multy_select w100p" multiple="multiple" id="codeStatusBrw" name="codeStatusBrw">
                <c:forEach var="list" items="${codeStatus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
          </tr>
          <!-- <tr>
            <th scope="row"><spring:message code="svc.title.text.effectiveDate"/> & <spring:message code="svc.title.text.expireDate"/></th>
            <td>
                <div class="date_set w100p">
                  <p><input id="listStartEffectiveDt" name="startEffectiveDt" type="text" value="" title="Start Effective Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                  <span>~</span>
                  <p><input id="listEndEffectiveDt" name="endEffectiveDt" type="text" value="" title="End Effective Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                </div>
            </td>
            <th scope="row"></th>
            <td></td>
            <th scope="row"></th>
            <td></td>
         </tr> -->
        </tbody>
      </table>

      <!-- <aside class="link_btns_wrap">
        <p class="show_btn">
            <a href="javascript:void(0);">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" />
            </a>
        </p>
        <dl class="link_list">
          <dt>Link</dt>
          <dd>
            <ul class="btns"></ul>
            <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
          </dd>
        </dl>
      </aside> -->

      <br/>

       <ul class="right_btns">
         <li>
           <p class="btn_grid">
             <a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a>
           </p>
         </li>
       </ul>
    </form>
  </section>

  <section class="search_result">
    <article class="grid_wrap">
      <div id="largeGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
    </article>
  </section>
</section>