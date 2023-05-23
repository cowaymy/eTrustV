<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;
    var excelGridID;

    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        createAUIGridExcel();

      //AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#payCnvrId").val(event.item.payCnvrId);
            Common.popupDiv("/sales/order/paymodeConversionDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'detailPop');
        });
    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "payCnvrNo",
                headerText : "<spring:message code='sal.title.text.batchNo' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrStusFrom",
                headerText : "<spring:message code='sal.title.text.statusFrom' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrStusTo",
                headerText : "<spring:message code='sal.title.text.statusTo' />",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrTotalItm",
                headerText : "Total Item",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrCrtDt",
                headerText : "<spring:message code='sal.text.createDate' />",
                width : 110,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "username1",
                headerText : "Creator",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payCnvrId",
                visible : false
            }];



     // 그리드 속성 설정
        var gridPros = {

            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
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
            showRowNumColumn : false,

            groupingMessage : "Here groupping"
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function createAUIGridExcel(){
        // added by Adib 06/04/2023
        var excelColumnLayout = [ {
            dataField : "salesOrdNo",
            headerText : "ORDERNO",
            width : 80,
            editable : false
            }, {
            dataField : "crtDt",
            headerText : "DATE",
            dataType : "date",
            formatString : "dd/mm/yyyy" ,
            width : 90,
            editable : false
            }, {
            dataField : "oldPmode",
            headerText : "OLDPAYMODE",
            width : 100,
            editable : false
            }, {
            dataField : "newPmode",
            headerText : "NEWPAYMODE",
            width : 80,
            editable : false
            }, {
            dataField : "remark",
            headerText : "REMARKS",
            width : 120,
            editable : false
            }, {
            dataField : "reqdesc",
            headerText : "REQDESC",
            width : 120,
            editable : false,
            }, {
            dataField : "creator",
            headerText : "CREATOR",
            width : 80,
            editable : false
            }, {
            dataField : "saleskeyinbranch",
            headerText : "SALESKEYINBRANCH",
            width : 100,
            editable : false
            }, {
            dataField : "platform",
            headerText : "PLATFORM",
            width : 80,
            editable : false
            }];

        var excelGridPros = {
                enterKeyColumnBase : true,
                useContextMenu : true,
                enableFilter : true,
                showStateColumn : true,
                displayTreeOpen : true,
                showRowNumColumn : false,
                noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
                groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
                exportURL : "/common/exportGrid.do"
            };

         excelGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);

    }

    function fn_searchListAjax(){
    	console.log(myGridID);
        Common.ajax("GET", "/sales/order/paymodeConversionList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
            console.log(myGridID);
        });
    }

    function fn_newConvert(){
        Common.popupDiv("/sales/order/paymodeConversion.do", $("#detailForm").serializeJSON(), null, true, 'savePop');
    }

    function fn_diffDate(startDt, endDt) {
        var arrDt1 = startDt.split("/");
        var arrDt2 = endDt.split("/");

        var dt1 = new Date(arrDt1[2], arrDt1[1]-1, arrDt1[0]);
        var dt2 = new Date(arrDt2[2], arrDt2[1]-1, arrDt2[0]);

        var diff = new Date(dt2 - dt1);
        var day = diff/1000/60/60/24;

        return day;
    }

    function fn_genOrdListRpt(){
    	console.log(excelGridID);

        var msg = "";

        var morgrid;

          if(FormUtil.isEmpty($('#createStDate').val()) || FormUtil.isEmpty($('#createEnDate').val())) {
              msg += 'Please fill in create date';
              Common.alert(msg);
          }
          else {
        	  console.log($('#createStDate').val());
              console.log($('#createEnDate').val());

              var diffDay = fn_diffDate($('#createStDate').val(), $('#createEnDate').val());

              if(diffDay > 181 || diffDay < 0) {
                  msg += 'Create date must be within 6 months';
                  Common.alert(msg);
              }
              else {

            	  Common.ajax("GET", "/sales/order/countPaymodeCnvrExcelList.do", $("#searchForm").serialize(), function(result) {
                      var cnt = result;
                      if(cnt > 0){
                          Common.showLoader();
                          $.fileDownload("/sales/order/paymodeCnvrOrdListRpt2.do?createStDate=" + $('#createStDate').val() + "&createEnDate="+$('#createEnDate').val())
                          .done(function () {
                              Common.alert("<spring:message code='pay.alert.fileDownSuceess'/>");
                              Common.removeLoader();
                          })
                          .fail(function () {
                              Common.alert("<spring:message code='pay.alert.fileDownFailed'/>");
                              Common.removeLoader();
                          });
                      }
                      else{
                          Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
                      }
                  });
            	  }
              }
    }

    function fn_excelDown(){
        GridCommon.exportTo("excel_list_grid_wrap", "xlsx", "OrderListReport");
    }



    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
                this.value = '';
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
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Paymode Conversion List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_newConvert()"><spring:message code="sal.btn.new" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>

    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="payCnvrId" name="payCnvrId">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
        <col style="width:160px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
        <tbody>
            <tr>
                <th scope="row">Batch No</th>
                <td colspan="3">
                <input type="text" title="" id="batchNo" name="batchNo" placeholder="Batch Number" class="w100p" />
                </td>
                <th scope="row"><spring:message code="sal.text.createDate" /></th>
                <td>
                <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                <span>To</span>
                <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                </div><!-- date_set end -->
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.statusFrom" /></th>
                <td>
                <select class="multy_select w100p" id="cmbStatusFr" name="cmbStatusFr" multiple="multiple">
                    <option value="CRC">CRC</option>
                    <option value="DD">DD</option>
                </select>
                </td>
                <th scope="row"><spring:message code="sal.title.text.statusTo" /></th>
                <td>
                <select class="multy_select w100p" id="cmbStatusTo" name="cmbStatusTo" multiple="multiple">
                    <option value="REG"><spring:message code="sal.combo.text.regular" /></option>

                </select>
                </td>
                <th scope="row"><spring:message code="sal.text.creator" /></th>
                <td>
                <input type="text" title="" id="crtUserName" name="crtUserName" placeholder="Username)" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.remark" /></th>
                <td colspan="3">
                <input type="text" title="" id="batchRem" name="batchRem" placeholder="Customer ID(Number Only)" class="w100p" />
                </td>

            </tr>
        </tbody>
    </table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>

    <ul class="btns">
        <li><p class="link_btn"><a href="#" onclick="javascript: fn_genOrdListRpt();"> Order List Report</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>

 <div id="excel_list_grid_wrap" style="display: none;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->