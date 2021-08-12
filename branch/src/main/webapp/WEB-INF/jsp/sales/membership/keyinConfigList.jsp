<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript">

    var listGridID;
    var myGridID;
    var cpGridID;
    var filterGrid;
    var spareGrid;
    var serviceGrid;
    var priceHistoryGrid;
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "7","codeName": "Obsolete"},{"codeId": "8","codeName": "Inactive"}];
    var srvMembershipList = new Array();
    var gridNm;
    var chkNum;// 그리드 체크
    var selectRowIdx = -1;

    // AUIGrid 칼럼 설정
  var columnLayout = [{dataField:   "stkid",headerText :"<spring:message code='log.head.stockid'/>"            ,width:120 ,height:30, visible : false},
                            {dataField: "stkcode",headerText :"<spring:message code='log.head.materialcode'/>"           ,width:120 ,height:30 , editable : false},
                            {dataField: "stkdesc",headerText :"<spring:message code='log.head.materialname'/>"           ,width:250 ,height:30,style :  "aui-grid-user-custom-left" , editable : false},
                            {dataField: "stkcategoryid",headerText :"<spring:message code='log.head.categoryid'/>"        ,width:120,height:30 , visible : false},
                            {dataField: "codename",headerText :"<spring:message code='log.head.category'/>"       ,width:140 ,height:30, editable : false},
                            {dataField: "stktypeid",headerText :"<spring:message code='log.head.typeid'/>"            ,width:120 ,height:30, visible : false},
                            {dataField: "codename1",headerText :"<spring:message code='log.head.type'/>"              ,width:120 ,height:30, editable : false},
                            {dataField: "name",headerText :"<spring:message code='log.head.status'/>"       ,width:120 ,height:30, editable : false},
                            {dataField: "statuscodeid",headerText :"<spring:message code='log.head.statuscodeid'/>"     ,width:120 ,height:30 , visible : false},
                            {dataField: "allowSales",headerText :"Allow Sales"     ,width:120 ,height:30 , editable : true ,  visible : false},
                            {dataField: "allowSalesStatus",headerText :"Allow Sales Status"     ,width:200 ,height:30 , editable : false}
                       ];

 // 그리드 속성 설정
    var gridPros = {
        // 페이지 설정
        usePaging : true,
        showFooter : false,
        fixedColumnCount : 1,
        // 편집 가능 여부 (기본값 : false)
        editable : true,
        // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
        enterKeyColumnBase : true,
        // 셀 선택모드 (기본값: singleCell)
        //selectionMode : "multipleCells",
        // 컨텍스트 메뉴 사용 여부 (기본값 : false)
        useContextMenu : true,
        // 필터 사용 여부 (기본값 : false)
        enableFilter : true,
        // 그룹핑 패널 사용
        useGroupingPanel : false,
        // 상태 칼럼 사용
        showStateColumn : true,
        // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
        displayTreeOpen : true,
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
        groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
        //selectionMode : "multipleCells",
        //rowIdField : "stkid",
        enableSorting : true,
        showRowCheckColumn : false,

    };

    $(document).ready(function(){
        createAUIGrid(columnLayout);
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.bind(myGridID , "cellClick", function( event ){
            selectRowIdx = event.rowIndex;
        });

        doDefCombo(comboData, '' ,'cmbStatus', 'M', 'f_multiCombo');
    });

    $(function(){

        $('#_btnFail').click(function() {
        	if(fn_validStatus()){
        	$('#txtMaterialCode').text(AUIGrid.getCellValue(myGridID, selectRowIdx, "stkcode"));
        	$('#txtMaterialName').text(AUIGrid.getCellValue(myGridID, selectRowIdx, "stkdesc"));
        	$('#hiddenStkId').text(AUIGrid.getCellValue(myGridID, selectRowIdx, "stkid"));
            $('#prompt_wrap').show();
        	}
        });

        $('#_btnFailSave').click(function() {
            fn_doFailStatus();
        });

        $("#search").click(function(){
            $('#subDiv').hide();
            getSampleListAjax();
        });

        $("#clear").click(function(){
            doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //청구처 리스트 조회
          //  doGetCombo('/common/selectCodeList.do', '15', '','cmbType', 'M' , 'f_multiCombo'); //청구처 리스트 조회
            doDefCombo(comboData, '','cmbStatus', 'M', 'f_multiCombo');
            $("#stkCd").val('');
            $("#stkNm").val('');
        });

        hideViewPopup=function(val){
            $(val).hide();
        }

        $("#stkCd").keypress(function(event) {
            if (event.which == '13') {
                $("#svalue").val($("#stkCd").val());
                $("#sUrl").val("/logistics/material/materialcdsearch.do");
                Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
            }
        });
    });

    function fn_stusPrintPop() {
     /*    fn_getKeyInConfigList(); */
        getSampleListAjax();// refresh with latest records
        $('#prompt_wrap').hide();
    }

    function fn_doFailStatus(){

         var txtAlwSales = $('#alwSales option:selected').val().trim();
         var txtMaterialCode = AUIGrid.getCellValue(myGridID, selectRowIdx, "stkcode");
         var hiddenStkId = AUIGrid.getCellValue(myGridID, selectRowIdx, "stkid");
         var dbAlwSales = AUIGrid.getCellValue(myGridID, selectRowIdx, "allowSales");

         if(dbAlwSales == txtAlwSales ){
             Common.alert("You does not make any changes.");
             return;
         }

        var failUpdOrd = {
        		stkcode         : txtMaterialCode,
        		alwSales       : txtAlwSales,
        		stkid             : hiddenStkId
        }
        console.log (failUpdOrd);

        Common.confirm("Confirm to update status for Material Code " + txtMaterialCode + " ? " , function(){
            Common.ajax("POST", "/sales/membership/updateAllowSalesStatus.do", failUpdOrd, function(result) {
                Common.alert("Order Failed" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_stusPrintPop);
            },
            function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.</b>");
                } catch (e) {
                    console.log(e);
                }
            });
        });
    }

    function getMainListAjax(_da) {

        var param = $('#searchForm').serialize();
        var selcell = 0;
        var selectedItems = AUIGrid.getSelectedItems(myGridID);
        for (i = 0; i < selectedItems.length; i++) {
            selcell = selectedItems[i].rowIndex;
        }
        Common.ajax("GET" , "/sales/membership/keyinConfig.do" , param , function(data){
                var gridData = data;
                AUIGrid.setGridData(myGridID, gridData.data);
                AUIGrid.setSelectionByIndex(myGridID, selcell, 3);
                $("#" + _da.revalue).click();
        });
    }

     function fn_validStatus() {
        var isValid = true;
        if(selectRowIdx < 0){
           Common.alert("Material Missing" + DEFAULT_DELIMITER + "<b>No Material Item Selected.</b>");
           isValid = false;
        }
        return isValid;
    }

    // AUIGrid 를 생성합니다.
    function createAUIGrid(columnLayout) {
        // 실제로 #grid_wrap 에 그리드 생성
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    function getSampleListAjax() {
     var param = $('#searchForm').serialize();
        console.log(param);
        Common.ajax("GET" , "/sales/membership/keyinConfigList.do" , param , function(data){
            console.log(data);
            var gridData = data;
            AUIGrid.setGridData(myGridID, gridData.data);
        });
    }
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '11', '', 'cmbCategory', 'M', 'f_multiCombo');
 //   doGetCombo('/common/selectCodeList.do', '15', '', 'cmbType', 'M','f_multiCombo');
    //doDefCombo(comboData, '' ,'cmbStatus', 'M', 'f_multiCombo');

    function f_multiCombo() {
        $(function() {
            $('#cmbCategory').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            });
            $('#cmbStatus').change(function() {
            }).multipleSelect({
                selectAll : true,
                width : '80%'
            });
        });
    }

    function removeRow(rowIndex, gridNm, num) {

        AUIGrid.removeRow(gridNm, rowIndex);
        AUIGrid.removeSoftRows(gridNm);

          if (num == 1) {
              $("#filter_info_edit").text("SAVE");
        } else if (num == 2) {
              $("#spare_info_edit").text("SAVE");
        } else if (num == 3){
              $("#service_info_edit").text("SAVE");
        }
    }

</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv">
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
        <li>Sales</li>
        <li>Membership</li>
    </ul>
    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Key In Configuration</h2>
        <ul class="right_opt">
          <%//@ include file="/WEB-INF/jsp/common/contentButton.jsp" %>
        <li><p class="btn_blue"><a id="_btnFail" href="#">Update Status</a></p></li>
                <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Category</th>
                    <td>
                        <select  id="cmbCategory" name="cmbCategory" class="w100p"></select>
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select  id="cmbStatus" name="cmbStatus" class="w100p"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type=text name="stkCd" id="stkCd" class="w100p" value=""/>
                    </td>
                    <th scope="row">Material Name</th>
                    <td>
                        <input type=text name="stkNm" id="stkNm" class="w100p" value=""/>
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->
    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
        </ul>
        <div id="grid_wrap" class="mt10" style="height:450px"></div>
        <section id="subDiv" style="display:none;" class="tap_wrap"><!-- tap_wrap start -->

            <!-- service_point -->

        </section><!--  tab -->
    </section><!-- data body end -->

<!---------------------------------------------------------------
    POP-UP (ALLOW SALES STATUS)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap size_small"  id="prompt_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="updFail_pop_header">
        <h1>Update Status</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#prompt_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="updFailForm" id="updFailForm"  method="post">
    <input id="hiddenStkId" name="stkId"   type="hidden"/>

    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                <tr>
                    <th scope="row">Material Code</th>
                    <!-- <td id="view_sofNo"></td> -->
                    <td colspan="3" id="txtMaterialCode" ></td>
                    </tr>
                    <tr>
                    <th scope="row">Material Name</th>
                    <td colspan="3" id="txtMaterialName" ></td>
                </tr>
                <tr>
                     <th scope="row">Allow Sales Status<span class="must" width="100%">*</span></th>
                   <!--   <td colspan="3" ><select ass="mr5" id="_action" name="_action"></select></td> -->
                    <td colspan="3"><select class="w100p" id="alwSales" name="alwSales">
        <option value="1" >ALLOW SALES</option>
        <option value="0" >DISALLOW SALES</option>
    </select>
    </td>
                 </tr>
                </tbody>
            </table>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a id="_btnFailSave" href="#">Save</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
    </section><!-- content end -->
</div>


