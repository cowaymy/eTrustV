<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 17/09/2019  ONGHC  1.0.0          Create Defect Type Pop
 -->
<head>
<script type="text/javaScript" language="javascript">
  //AUIGrid 생성 후 반환 ID
  var myGridIDDftTyp;

  $(document).ready(
      function() {
        createAUIGrid();

        AUIGrid.bind(myGridIDDftTyp, "cellDoubleClick", function(event) {
          fn_setData(event.item);
        });

        fn_selectPstRequestDOListAjax(); // AUTO SEARCH
      });

  $(function() {

  });

  function fn_setData(item) {
    fn_loadDftCde(item, "${callPrgm}");
    $('#custPopCloseBtn').click();
  }

  function createAUIGrid() {
    var cdeTtl = "";
    if ("${callPrgm}" == "DT") {
      cdeTtl = "<spring:message code='service.text.dftTypCde'/>";
    } else if ("${callPrgm}" == "DC") {
      cdeTtl = "<spring:message code='service.text.dftCde'/>";
    } else if ("${callPrgm}" == "DP") {
      cdeTtl = "<spring:message code='service.text.dftPrtCde'/>";
    } else if ("${callPrgm}" == "DD") {
      cdeTtl = "<spring:message code='service.text.dftDtlCde'/>";
    } else if ("${callPrgm}" == "SC") {
      cdeTtl = "<spring:message code='service.text.solCde'/>";
    }

    var columnLayout = [ {
      headerText : "ID",
      dataField : "id",
      width : 50,
      visible : false
    }, {
      headerText : cdeTtl,
      dataField : "code",
       width : 110
    }, {
      headerText : "<spring:message code='sys.label.description'/>",
      dataField : "descp",
      width : 350
    }, {
      headerText : "<spring:message code='service.title.Remark'/>",
      dataField : "rmk",
      width : 500
    } ];

    var gridPros = {
      usePaging : true,
      pageRowCount : 10,
      editable : false,
      fixedColumnCount : 0,
      showStateColumn : false,
      displayTreeOpen : false,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      noDataMessage : "No record found.",
      groupingMessage : "Here groupping"
    };

    myGridIDDftTyp = GridCommon.createAUIGrid("grid_cust_wrap", columnLayout, "", gridPros);
  }

  function fn_selectPstRequestDOListAjax() {

    if ($('#code').val() != "" && $('#code').val() != null) {
      $('#search1').val('%' + $('#code').val() + '%');
    } else {
      $('#search1').val("");
    }

    if ($('#desc').val() != "" && $('#desc').val() != null) {
      $('#search2').val('%' + $('#desc').val() + '%');
    } else {
      $('#search2').val("");
    }

    if ($('#rmk').val() != "" && $('#rmk').val() != null) {
        $('#search3').val('%' + $('#rmk').val() + '%');
      } else {
        $('#search3').val("");
      }

    Common.ajax("GET", "/services/as/getDftTyp.do", $("#dftSearchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridIDDftTyp, result);
    });
  }
</script>
</head>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <c:choose>
   <c:when test="${callPrgm=='DT'}">
     <h1><spring:message code='service.title.dftTypS'/></h1>
   </c:when>
   <c:when test="${callPrgm=='DC'}">
     <h1><spring:message code='service.title.dftCdeS'/></h1>
   </c:when>
   <c:when test="${callPrgm=='DP'}">
     <h1><spring:message code='service.title.dftPrtS'/></h1>
   </c:when>
   <c:when test="${callPrgm=='DD'}">
     <h1><spring:message code='service.title.dftDtlS'/></h1>
   </c:when>
   <c:when test="${callPrgm=='SC'}">
     <h1><spring:message code='service.title.solCdeS'/></h1>
   </c:when>
  </c:choose>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="custPopCloseBtn" href="#"><spring:message code='sys.btn.close'/></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form id="dftSearchForm" name="searchForm" action="#" method="post">
    <input id="callPrgm" name="callPrgm" value="${callPrgm}" type="hidden" />
    <input id="prodCde" name="prodCde" value="${prodCde}" type="hidden" />
    <input id="ddCde" name="ddCde" value="${ddCde}" type="hidden" />
     <input id="dtCde" name="dtCde" value="${dtCde}" type="hidden" />
    <input id="search1" name="search1" type="hidden" />
    <input id="search2" name="search2" type="hidden" />
    <input id="search3" name="search3" type="hidden" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 200px" />
      <col style="width: *" />
      <col style="width: 200px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row">

         <c:choose>
           <c:when test="${callPrgm=='DT'}">
             <spring:message code='service.text.dftTypCde'/>
           </c:when>
           <c:when test="${callPrgm=='DC'}">
             <spring:message code='service.text.dftCde'/>
           </c:when>
           <c:when test="${callPrgm=='DP'}">
             <spring:message code='service.text.dftPrtCde'/>
           </c:when>
           <c:when test="${callPrgm=='DD'}">
             <spring:message code='service.text.dftDtlCde'/>
           </c:when>
           <c:when test="${callPrgm=='SC'}">
             <spring:message code='service.text.solCde'/>
           </c:when>
         </c:choose>

       </th>
       <td><input id="code" name="code" type="text" title="" placeholder="Code" class="w100p" onkeyup="this.value = this.value.toUpperCase();" /></td>
       <th scope="row"><spring:message code='sys.label.description'/></th>
       <td><input id="desc" name="desc" type="text" title="" placeholder="<spring:message code='sys.label.description'/>" class="w100p" onkeyup="this.value = this.value.toUpperCase();" /></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.Remark'/></th>
       <td colspan="3"><input id="rmk" name="rmk" type="text" title="" placeholder="<spring:message code='service.title.Remark'/>" class="w100p" onkeyup="this.value = this.value.toUpperCase();" /></td>
      </tr>
     </tbody>
    </table>
    <span id='reminder' style="color:red;font-style:italic;"><spring:message code='service.msg.dblClickSel' /></span>
    <!-- table end -->
   </form>
   <section class="search_result">
    <!-- search_result start -->
    <ul class="right_btns">
     <li><p class="btn_grid">
       <a href="#" onClick="fn_selectPstRequestDOListAjax();"><spring:message code='sys.btn.search'/></a>
      </p></li>
     <li><p class="btn_grid">
       <a href="#"><spring:message code='sys.btn.clear'/></a>
      </p></li>
    </ul>
    <article class="grid_wrap">
     <!-- grid_wrap start -->
     <div id="grid_cust_wrap"
      style="width: 100%; height: 380px; margin: 0 auto;"></div>
    </article>
    <!-- grid_wrap end -->
   </section>
   <!-- search_result end -->
  </section>
  <!-- search_table end -->
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->