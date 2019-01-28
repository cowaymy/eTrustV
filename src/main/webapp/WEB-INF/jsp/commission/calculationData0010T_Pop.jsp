<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
  text-align: left;
  margin-top: -20px;
}
</style>
<script type="text/javaScript">
  var myGridID_10T;
  var gridDataLength = 0;
  var today = "${today}";

  $(document)
      .ready(
          function() {
            createAUIGrid();

            // ready 이벤트 바인딩
            AUIGrid.bind(myGridID_10T, "ready",
                function(event) {
                  gridDataLength = AUIGrid
                      .getGridData(myGridID_10T).length; // 그리드 전체 행수 보관
                });

            // cellClick event.
            AUIGrid.bind(myGridID_10T, "cellClick",
                function(event) {
                  console.log("rowIndex : " + event.rowIndex
                      + ", columnIndex : "
                      + event.columnIndex + " clicked");
                });

            // 헤더 클릭 핸들러 바인딩
            AUIGrid
                .bind(
                    myGridID_10T,
                    "headerClick",
                    function(event) {
                      // isExclude 칼럼 클릭 한 경우
                      if (event.dataField == "isExclude") {
                        if (event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
                          var isChecked = document
                              .getElementById("allCheckbox").checked;
                          checkAll(isChecked);
                        }
                        return false;
                      }
                    });

            // 셀 수정 완료 이벤트 바인딩
            AUIGrid
                .bind(
                    myGridID_10T,
                    "cellEditEnd",
                    function(event) {

                      // isActive 칼럼 수정 완료 한 경우
                      if (event.dataField == "isExclude") {

                        // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
                        var activeItems = AUIGrid
                            .getItemsByValue(
                                myGridID_10T,
                                "isExclude",
                                "1");

                        // 헤더 체크 박스 전체 체크 일치시킴.
                        if (activeItems.length != gridDataLength) {
                          document
                              .getElementById("allCheckbox").checked = false;
                        } else if (activeItems.length == gridDataLength) {
                          document
                              .getElementById("allCheckbox").checked = true;
                        }
                      }
                    });

            //Rule Book Item search
            $("#search_10T")
                .click(
                    function() {
                      Common
                          .ajax(
                              "GET",
                              "/commission/calculation/selectDataCMM010T",
                              $("#form_10T")
                                  .serialize(),
                              function(result) {
                                console
                                    .log("성공.");
                                console
                                    .log("data : "
                                        + result);
                                AUIGrid
                                    .setGridData(
                                        myGridID_10T,
                                        result);
                                //AUIGrid.addCheckedRowsByValue(myGridID_10T, "isExclude", "1");
                              });
                    });

            $("#save_10T")
                .click(
                    function() {
                      Common
                          .confirm(
                              "<spring:message code='sys.common.alert.save'/>",
                              fn_saveExculde);
                    });

            $('#memBtn').click(
                function() {
                  //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
                  Common.popupDiv("/common/memberPop.do", $(
                      "#form_10T").serializeJSON(), null,
                      true);
                });

          });

  function fn_loadOrderSalesman(memId, memCode) {
    $("#salesPersonCd_10T").val(memCode);
    console.log('fn_loadOrderSalesman memId:' + memId);
    console.log('fn_loadOrderSalesman memCd:' + memCode);
  }

  function fn_saveExculde() {
    Common.ajax("POST", "/commission/calculation/updatePrdData_10T.do",
        GridCommon.getEditData(myGridID_10T), function(result) {
          // 공통 메세지 영역에 메세지 표시.
          Common.setMsg("<spring:message code='sys.msg.success'/>");
          $("#search_10T").trigger("click");
        });
  }

  function createAUIGrid() {
    var columnLayout3 = [
        /*{
          dataField : "isExclude",
          headerText : '<spring:message code="commission.text.grid.exclude"/><br/><input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
          width : 65,
          renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"
          }
        },*/
        {
          dataField : "mbrshId",
          headerText : "<spring:message code='commissiom.text.excel.memsId'/>",
          style : "my-column",
          editable : false
        },
        {
          dataField : "ordId",
          headerText : "<spring:message code='commissiom.text.excel.ordId'/>",
          style : "my-column",
          editable : false
        },
        {
          dataField : "salesPersonId",
          headerText : "<spring:message code='commissiom.text.excel.salesPersonId'/>",
          style : "my-column",
          editable : false
        },
        {
          dataField : "emplyCode",
          headerText : "<spring:message code='commissiom.text.excel.salesPersonCd'/>",
          style : "my-column",
          editable : false
        },
        {
          dataField : "mbrshAmt",
          headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",
          style : "my-column",
          editable : false
        }, {
          dataField : "runId",
          style : "my-column",
          visible : false,
          editable : false
        }, {
          dataField : "taskId",
          style : "my-column",
          visible : false,
          editable : false
        } ];
    // 그리드 속성 설정
    var gridPros = {
      // 페이징 사용
      usePaging : true,
      // 한 화면에 출력되는 행 개수 20(기본값:20)
      pageRowCount : 20,
      // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      skipReadonlyColumns : true,
      // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      wrapSelectionMove : true,
      // 줄번호 칼럼 렌더러 출력
      showRowNumColumn : true,
      selectionMode : "singleRow",
      headerHeight : 40

    };
    myGridID_10T = AUIGrid
        .create("#grid_wrap_10T", columnLayout3, gridPros);
  }

  // 전체 체크 설정, 전체 체크 해제 하기
  function checkAll(isChecked) {

    var rowCount = AUIGrid.getRowCount(myGridID_10T);

    if (isChecked) { // checked == true == 1
      for (var i = 0; i < rowCount; i++) {
        AUIGrid.updateRow(myGridID_10T, {
          "isExclude" : 1
        }, i);
      }
    } else { // unchecked == false == 0
      for (var i = 0; i < rowCount; i++) {
        AUIGrid.updateRow(myGridID_10T, {
          "isExclude" : 0
        }, i);
      }
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
  };

  function fn_downFile() {
    Common
        .ajax(
            "GET",
            "/commission/calculation/cntCMM0010T",
            $("#form_10T").serialize(),
            function(result) {
              var cnt = result;
              if (cnt > 0) {
                var fileName = $("#fileName").val() + "_"
                    + today;
                fileName = fileName + ".xlsx";
                var searchDt = $("#CMM0010T_Dt").val();
                var year = searchDt.substr(searchDt
                    .indexOf("/") + 1, searchDt.length);
                var month = searchDt.substr(0, searchDt
                    .indexOf("/"));
                var code = $("#code_10T").val();

                var codeId = $("#orgGroup_10").val();
                var salesPersonCd = $("#salesPersonCd_10T")
                    .val();
                var ordId = $("#ordId_10T").val();
                var useYnCombo = $("#useYnCombo_10T").val();
                //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
                //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");

                //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&salesPersonCd="+salesPersonCd+"&ordId="+ordId+"&useYnCombo="+useYnCombo+"&codeId="+codeId+"'/>";

                Common.showLoader();
                $
                    .fileDownload(
                        "/commExcelFile.do?fileName="
                            + fileName + "&year="
                            + year + "&month="
                            + month + "&code="
                            + code
                            + "&salesPersonCd="
                            + salesPersonCd
                            + "&ordId=" + ordId
                            + "&useYnCombo="
                            + useYnCombo
                            + "&codeId=" + codeId)
                    .done(
                        function() {
                          //Common.alert('File download a success!');
                          Common
                              .alert("<spring:message code='commission.alert.report.download.success'/>");
                          Common.removeLoader();
                        })
                    .fail(
                        function() {
                          //Common.alert('File download failed!');
                          Common
                              .alert("<spring:message code='commission.alert.report.download.fail'/>");
                          Common.removeLoader();
                        });
              } else {
                Common
                    .alert("<spring:message code='sys.info.grid.noDataMessage'/>");
              }
            });
  }

  function fn_AlldownFile() {
    var data = {
      "searchDt" : $("#CMM0010T_Dt").val(),
      "code" : $("#code_10T").val(),
      "codeId" : $("#orgGroup_10").val()
    };
    Common
        .ajax(
            "GET",
            "/commission/calculation/cntCMM0010T",
            data,
            function(result) {
              var cnt = result;
              if (cnt > 0) {
                var fileName = $("#fileName").val() + "_"
                    + today;
                fileName = fileName + ".xlsx";
                var searchDt = $("#CMM0010T_Dt").val();
                var year = searchDt.substr(searchDt
                    .indexOf("/") + 1, searchDt.length);
                var month = searchDt.substr(0, searchDt
                    .indexOf("/"));
                var code = $("#code_10T").val();
                var codeId = $("#orgGroup_10").val();
                //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&codeId="+codeId+"'/>";

                Common.showLoader();
                $
                    .fileDownload(
                        "/commExcelFile.do?fileName="
                            + fileName + "&year="
                            + year + "&month="
                            + month + "&code="
                            + code + "&codeId="
                            + codeId)
                    .done(
                        function() {
                          //Common.alert('File download a success!');
                          Common
                              .alert("<spring:message code='commission.alert.report.download.success'/>");
                          Common.removeLoader();
                        })
                    .fail(
                        function() {
                          //Common.alert('File download failed!');
                          Common
                              .alert("<spring:message code='commission.alert.report.download.fail'/>");
                          Common.removeLoader();
                        });
              } else {
                Common
                    .alert("<spring:message code='sys.info.grid.noDataMessage'/>");
              }
            });
  }

  function onlyNumber(obj) {
    $(obj).keyup(function() {
      $(this).val($(this).val().replace(/[^0-9]/g, ""));
    });
  }
</script>
<div id="popup_wrap2" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>${prdDec }</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body" style="max-height: 600px;">
  <!-- pop_body start -->
  <aside class="title_line">
   <!-- title_line start -->
   <h2>${prdNm }-${prdDec }</h2>
  </aside>
  <!-- title_line end -->
  <form id="form_10T">
   <input type="hidden" name="code" id="code_10T" value="${code}" /> <input
    type="hidden" id="fileName" name="fileName"
    value="outrightMembership.xlsx" />
   <ul class="right_btns">
    <li><p class="btn_blue">
      <a href="#" id="search_10T"><span class="search"></span>
      <spring:message code='sys.btn.search' /></a>
     </p></li>
   </ul>
   <table class="type1 mt10">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
     <col style="width: 130px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message
        code='commission.text.search.monthYear' /><span class="must">*</span></th>
      <td><input type="text" title="Create start Date"
       placeholder="DD/MM/YYYY" name="searchDt" id="CMM0010T_Dt"
       class="j_date2" value="${searchDt_pop }" /></td>
      <th scope="row"><spring:message
        code='commission.text.search.orgGroup' /><span class="must">*</span></th>
      <td><select id="orgGroup_10" name="codeId"
       style="width: 100px;">
        <c:forEach var="list" items="${orgGrList }">
         <option value="${list.cdid}">${list.cd}</option>
        </c:forEach>
      </select></td>
      <th scope="row"><spring:message
        code='commissiom.text.excel.salesPersonCd' /></th>
      <td><input type="text" id="salesPersonCd_10T"
       name="salesPersonCd" style="width: 100px;" maxlength="10">
       <a id="memBtn" href="#" class="search_btn"><img
        src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
        alt="search" /></a></td>
     </tr>
     <tr>
      <th scope="row"><spring:message
        code='commissiom.text.excel.ordId' /></th>
      <td colspan='5'><input type="text" id="ordId_10T" name="ordId"
       style="width: 100px;" maxlength="10" onkeydown="onlyNumber(this)">
      </td>
      <!-- <th scope="row"><spring:message
        code='commission.text.isExclude' /></th>
      <td colspan="3"><select id="useYnCombo_10T" name="useYnCombo"
       style="width: 100px;">
        <option value="" selected></option>
        <option value="1">Y</option>
        <option value="0">N</option>
      </select></td> -->
     </tr>
    </tbody>
   </table>
   <!-- table end -->
  </form>
  <article class="grid_wrap3">
   <!-- grid_wrap start -->
   <!-- search_result start -->
   <ul class="right_btns">
    <li><p class="btn_grid">
      <a href="javascript:fn_AlldownFile()" id="addRow"><spring:message
        code='commission.button.allExcel' /></a>
     </p></li>
    <li><p class="btn_grid">
      <a href="javascript:fn_downFile()" id="addRow"><spring:message
        code='sys.btn.excel.dw' /></a>
     </p></li>
    <!-- <li><p class="btn_grid">
      <a href="#" id="save_10T"><spring:message code='sys.btn.save' /></a>
     </p></li>  -->
   </ul>
   <!-- grid_wrap start -->
   <div id="grid_wrap_10T"
    style="width: 100%; height: 334px; margin: 0 auto;"></div>
  </article>
  <!-- grid_wrap end -->
 </section>
</div>
