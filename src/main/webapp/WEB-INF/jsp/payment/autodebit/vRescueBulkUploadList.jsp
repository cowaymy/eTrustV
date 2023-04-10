<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid
  var myGridID, viewGridId;

  //Grid에서 선택된 RowID
  var selectedGridValue;

  // Empty Set
  var emptyData = [];

  $(document)
      .ready(
          function() {

            //Grid Properties
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

            myGridID = GridCommon.createAUIGrid("grid_wrap",
                columnLayout, null, gridPros);

/*             popupGridId = GridCommon.createAUIGrid("popup_grid_wrap",
            		popupColumnLayout, null, gridPros); */

            // Master Grid
            AUIGrid.bind(myGridID, "cellClick", function(event) {
              selectedGridValue = event.rowIndex;
            });

          });

  var columnLayout = [ {
      dataField : "batchNo",
      headerText : "<spring:message code='sal.title.text.batchNo' />",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "stus",
      headerText : "<spring:message code='sal.title.text.statusTo' />",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "totItem",
      headerText : "Total Item",
      width : 110,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "crtDt",
      headerText : "<spring:message code='sal.text.createDate' />",
      width : 110,
      dataType : "date",
      formatString : "dd/mm/yyyy" ,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "creator",
      headerText : "Creator",
      width : 140,
      editable : false,
      style: 'left_style'
  }, {
      dataField : "batchId",
      visible : false
  }];


  //AUIGrid popupColumnLayout
  var popupColumnLayout = [
      {
        dataField : "batchId",
        headerText : "Batch Id",
        width : 90,
        editable : false
      },
      {
          dataField : "batchNo",
          headerText : "Batch No",
          width : 90,
          editable : false
        },
      {
        dataField : "ordNo",
        headerText : "Order No",
        width : 90,
        editable : false
      },
      {
        dataField : "remark",
        headerText : "Remark",
        width : 150,
        editable : false
      },
      {
        dataField : "userName",
        headerText : "Uploaded By",
        width : 80,
        editable : false
      },
      {
        dataField : "crtDt",
        headerText : "Upload Date",
        width : 80,
        dataType : "date",
        formatString : "dd/mm/yyyy" ,
        editable : false,
        style: 'left_style'
      }];


  function fn_getSearchList() {
    Common.ajax("GET", "/payment/selectVRescueBulkList.do", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
    });
  }


  function fn_clear() {
    $("#searchForm")[0].reset();
  }

  //View Claim Pop-UP
  function fn_openDivPop(val) {

	  viewGridId = null;

	    if (val == "VIEW" || val == "CONFIRM" ) {

	      var selectedItem = AUIGrid.getSelectedIndex(myGridID);

	      if (selectedItem[0] > -1) {

	          var bchId = AUIGrid.getCellValue(myGridID, selectedGridValue,
	            "batchId");

              Common.ajax("GET", "/payment/selectVRescueBulkList.do", {
                  "bchId" : bchId
                }, function(result) {
                	console.log(result);
                  $("#view_wrap").show();
                  $("#new_wrap").hide();

                  $("#view_batchId").text(result[0].batchId);
                  $("#view_batchNo").text(result[0].batchNo);
                  $("#view_status").text(result[0].stus);
                  $("#view_creator").text(result[0].creator);
                  $("#view_createDt").text(result[0].crtDt2);
                  $("#view_totalItem").text(result[0].totItem);
                  $("#view_updator").text(result[0].updUserName);
                  $("#view_updateDate").text(result[0].updDt);
                });

              //Grid Properties
              var gridProsPopup = {
                      // 페이징 사용
                      usePaging : true,
                      // 한 화면에 출력되는 행 개수 20(기본값:20)
                      pageRowCount : 10,
                      editable : false,
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
                      showRowNumColumn : true,
                      groupingMessage : "Here groupping"
              };

              viewGridId = AUIGrid.create("view_grid_wrap", popupColumnLayout, gridProsPopup);
              Common.ajax("GET", "/payment/selectVRescueBulkDetails.do", {"batchId" : bchId}, function(result) {
                  AUIGrid.setGridData(viewGridId, result);
              });

	          if (val == "CONFIRM") {

	        	$('#view_grid_wrap').hide();
	        	$('#batchItmId').hide();
	            $('#pop_header h1').text(
                "CONFIRM BATCH UPLOAD");
                $('#center_btns1').show();

	          } else {

	        	  $('#view_grid_wrap').show();
	        	  $('#pop_header h1').text("VIEW BATCH UPLOAD");
	        	  $('#center_btns1').hide();
	          }

	        } else {
	          Common.alert("Please select a Batch Id");
	        }
	    }

	    else {

	    	$("#view_wrap").hide();
	        $("#new_wrap").show();
	        $("#newCnvrForm")[0].reset();
	    }

  }

  hideNewPopup = function(val) {

	    $(val).hide();
   }

  function fn_submitBulkUpload(){
	  if($("#fileSelector").val() == null || $("#fileSelector").val() == ""){
	        Common.alert("File not found. Please upload the file.");
	    } else {

 	    var formData = new FormData();
	    //formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
	    formData.append("csvFile", $("input[name=fileSelector]")[0].files[0]);

	    Common.ajaxFile("/payment/csvVRescueBulkUpload", formData, function (result) {

	        console.log(result);
	        Common.alert(result.message);

	        hideNewPopup('#new_wrap');

	    });
	    }
  }

  function fn_deFlag() {
	    Common
	        .confirm(
	            "Do you want to proceed to De-Flag this batch?",
	            function() {
	              var batchId = AUIGrid.getCellValue(myGridID,
	                  selectedGridValue, "batchId");

	              Common
	                  .ajax(
	                      "POST",
	                      "/payment/saveVRescueBulkConfirm.do",
	                      {
	                        "batchId" : batchId
	                      },
	                      function(result) {
	                   console.log(result);
	                        Common
	                            .alert(
	                                result.message);
	                        hideNewPopup('#view_wrap');
	                        fn_getSearchList();

	                      });
	            });
	  }

</script>
<!-- content start -->
<section id="content">
 <ul class="path">
  <li><img
   src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
   alt="Home" /></li>
 </ul>
 <!-- title_line start -->
 <aside class="title_line">
  <p class="fav">
   <a href="#" class="click_add_on"><spring:message
     code='pay.text.myMenu' /></a>
  </p>
  <h2>vRescue Bulk Upload</h2>
  <ul class="right_btns">
<%--   <li><p class="btn_blue"><a href="#" onClick="javascript:fn_openDivPop('NEW');"><spring:message code="sal.btn.new" /></a></p></li>
 --%>  <li><p class="btn_blue"><a href="javascript:fn_getSearchList();"><span class="search"></span> <spring:message code='sys.btn.search' /></a></p></li>
  <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span> <spring:message code='sys.btn.clear' /></a></p></li>
  </ul>
 </aside>
 <!-- title_line end -->
 <!-- search_table start -->
 <section class="search_table">
  <form name="searchForm" id="searchForm" method="post">
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 240px" />
     <col style="width: *" />
     <col style="width: 120px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row">Batch No</th>
      <td colspan="5"><input id="batchNo" name="batchNo" type="text"
       title="BatchNo" placeholder="Batch No" class="w100p" /></td>
      <th scope="row"><spring:message code='pay.text.crtDt' /></th>
      <td>
       <!-- date_set start -->
       <div class="date_set w100p">
        <p>
         <input id="createDt1" name="createDt1" type="text"
          title="Create Date From" placeholder="DD/MM/YYYY"
          class="j_date" readonly />
        </p>
        <span>To</span>
        <p>
         <input id="createDt2" name="createDt2" type="text"
          title="Create Date To" placeholder="DD/MM/YYYY" class="j_date"
          readonly />
        </p>
       </div> <!-- date_set end -->
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='pay.text.creator' /></th>
      <td colspan="5"><input id="creator" name="creator" type="text"
       title="Creator" placeholder="Creator (Username)" class="w100p" />
      </td>
      <th scope="row"></th>
      <td></td>
     </tr>
    </tbody>
   </table>
      <!-- link_btns_wrap start -->
   <aside class="link_btns_wrap">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
     <p class="show_btn">
      <a href="#"><img
       src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
       alt="link show" /></a>
     </p>
     <dl class="link_list">
      <dt>Link</dt>
      <dd>
       <ul class="btns">
        <li><p class="link_btn">
          <a href="javascript:fn_openDivPop('NEW');"><spring:message
            code='pay.btn.newUpload' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="javascript:fn_openDivPop('VIEW');"><spring:message
            code='sal.title.text.viewUploadBatch' /></a>
         </p></li>
        <li><p class="link_btn type2">
          <a href="javascript:fn_openDivPop('CONFIRM');"><spring:message
            code='sal.title.text.confirmUpload' /></a>
         </p></li>
       </ul>
       <p class="hide_btn">
        <a href="#"><img
         src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
         alt="hide" /></a>
       </p>
      </dd>
     </dl>
    </c:if>
   </aside>
   <!-- link_btns_wrap end -->
  </form>
 </section>
 <!-- search_table end -->
 <!-- search_result start -->
 <section class="search_result">
  <!-- grid_wrap start -->
  <article class="grid_wrap">
  <div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;">
</article>
  <!-- grid_wrap end -->
 </section>
 <!-- search_result end -->
</section>
<!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (VIEW UPLOAD / CONFIRM UPLOAD )
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
 <!-- pop_header start -->
 <header class="pop_header" id="pop_header">
  <h1></h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#" onclick="hideNewPopup('#view_wrap')"><spring:message
       code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>


 <!-- pop_header end -->
 <!-- pop_body start -->
 <section class="pop_body">
  <!-- search_table start -->
   <!-- table start -->
   <table class="type1">
    <caption>table</caption>
    <colgroup>
     <col style="width: 250px" />
     <col style="width: *" />
     <col style="width: 250px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='pay.text.bchID' /></th>
      <!-- BATCH ID -->
      <td id="view_batchId"></td>
      <th scope="row"><spring:message code='pay.text.stat' /></th>
      <!-- STATUS -->
      <td id="view_status"></td>
     </tr>
     <tr>
      <th scope="row">Batch No</th>
      <!-- CLAIM TYPE -->
      <td id="view_batchNo"></td>
            <th scope="row"><spring:message code='pay.text.ttlItm' /></th>
      <!-- TOTAL ITEM -->
      <td id="view_totalItem"></td>
     </tr>
     <tr>
            <!-- CREATOR -->
      <th scope="row"><spring:message code='pay.text.creator' /></th>
      <td id="view_creator"></td>
      <!-- CREATE DATE -->
            <th scope="row"><spring:message code='pay.text.crtDt' /></th>
      <td id="view_createDt"></td>
     </tr>
     <tr>

      <th scope="row"><spring:message code='pay.text.updator' /></th>
      <!-- UPDATOR -->
      <td id="view_updator"></td>
            <!-- UPDATE DATE -->

      <th scope="row">Update Date</th>
            <td id="view_updateDate"></td>
     </tr>
    </tbody>

   </table>

<aside id="batchItmId" class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.batchItem" /></h3>
</aside><!-- title_line end -->
      <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="view_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article>

  <ul class="center_btns" id="center_btns1">
   <li><p class="btn_blue2">
     <a href="javascript:fn_deFlag();">De-Flag</a>
    </p></li>
  </ul>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

<!--------------------------------------------------------------
    POP-UP (NEW UPLOAD)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display: none;">
 <!-- pop_header start -->
 <header class="pop_header" id="new_pop_header">
  <h1>
   vRescue Bulk Upload
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#" onclick="hideNewPopup('#new_wrap')"><spring:message
       code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <!-- pop_body start -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="newCnvrForm" name="newCnvrForm">
    <input id="hiddenTotal" name="hiddenTotal" type="hidden"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
            <tr>
                <th scope="row"><spring:message code="sal.text.selectYourCSVFile" /><span class="must">*</span></th>
                <td>

                     <div class="auto_file"><!-- auto_file start -->
                         <input type="file" title="file add"  id="fileSelector" name="fileSelector"/>
                     </div><!-- auto_file end -->
                </td>
            </tr>
            </tbody>
            </table><!-- table end -->
        </form>
<br>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_submitBulkUpload();"><spring:message code="sys.btn.submit" /></a></p></li>
</ul>
</section><!-- search_table end -->

</section><!-- pop_body end -->
</div>
<!-- popup_wrap end -->