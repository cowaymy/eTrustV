<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 09/10/2019  ONGHC  1.0.0          CREATE NEW LOCATION SEARCH
 -->
<head>
<script type="text/javaScript" language="javascript">
  //AUIGrid 생성 후 반환 ID
  var myGridIDDftTyp;

  $(document).ready(
      function() {
        createAUIGrid();

        doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'sfrLoctype', 'M','f_frloctype');

        AUIGrid.bind(myGridIDDftTyp, "cellDoubleClick", function(event) {
          fn_setData(event.item);
        });

        fn_selectPstRequestDOListAjax(); // AUTO SEARCH
      });

  $(function() {

  });

  function fn_setData(item) {
    fn_setRqstLoc(item);
    $('#custPopCloseBtn').click();
  }

  function createAUIGrid() {
    var columnLayout = [ {
      headerText : "<spring:message code='log.label.lctTyp'/>",
      dataField : "locTyp",
      width : 150
    }, {
      headerText : "<spring:message code='log.label.lctGrade'/>",
      dataField : "locGrade",
      width : 150
    },  {
      headerText : "<spring:message code='log.label.rqstlct'/>",
      dataField : "locId",
      width : 200,
      visible : false
    }, {
      headerText : "<spring:message code='log.label.rqstlct'/>",
      dataField : "locCde",
      width : 200,
      visible : false
    }, {
      headerText : "<spring:message code='log.label.rqstlct'/>",
      dataField : "locDesc",
      width : 650
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
    Common.ajax("GET", "/logistics/pos/getRqstLocLst.do", $("#RqstLctSearchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridIDDftTyp, result);
    });
  }

  function f_frloctype() {
    $(function() {
      $('#sfrLoctype').change(function() {
        if ($('#sfrLoctype').val() != null && $('#sfrLoctype').val() != "" ){
          var searchlocgb = $('#sfrLoctype').val();

          var locgbparam = "";
          for (var i = 0 ; i < searchlocgb.length ; i++){
            if (locgbparam == ""){
              locgbparam = searchlocgb[i];
            } else {
              locgbparam = locgbparam +"∈"+searchlocgb[i];
            }
          }
          $('#locTyp').val(locgbparam);
        }
      }).multipleSelect({
           selectAll : true
      });
    });
  }

  function fn_setLocGrd(obj) {
    var locGrade =  obj.value;
    $('#locTypGrd').val(locGrade);
  }

</script>
</head>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
    <h1><spring:message code='log.label.rqstlct'/></h1>
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
   <form id="RqstLctSearchForm" name="RqstLctSearchForm" action="#" method="post">
    <input id="locTyp" name="locTyp" value="" type="hidden" />
    <input id="locTypGrd" name="locTypGrd" value="" type="hidden" />
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
        <spring:message code='log.label.lctTyp'/>
       </th>
       <td>
        <select id="sfrLoctype" name="sfrLoctype" class="multy_select w100p" multiple="multiple"></select>
       </td>
       <th scope="row"><spring:message code='log.label.lctGrade'/></th>
       <td>
        <select id="sfrLocGrd" name="sfrLocGrd" class="w100p" onchange="fn_setLocGrd(this)">
          <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
          <option value="A">A</option>
          <option value="B">B</option>
        </select>
       </td>

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