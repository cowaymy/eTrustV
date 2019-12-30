<!--=================================================================================================
* Task  : Logistics
* File Name : countStockAuditList.jsp
* Description : Count-Stock Audit List
* Author : KR-OHK
* Date : 2019-10-07
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-07  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style type="text/css">

/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}

/* aui-grid-paging-number 클래스 재정의 */
.aui-grid-paging-panel .aui-grid-paging-number {
    border-radius : 4px;
}
</style>
<script type="text/javascript">

    var myGridID;
    var myExcelGridID;
    var mSort = {};

    var columnLayout = [
   {
        dataField: "stockAuditNo",
        headerText: "<spring:message code='log.head.stockauditno'/>",
        editable: false,
        visible: true,
        width : 130
    }
   ,{
       dataField: "locCode",
       headerText: "<spring:message code='log.head.locationcode'/>",
       editable: false,
       visible: true,
       width : 110
   }
   ,{
        dataField: "locDesc",
        headerText: "<spring:message code='log.head.locationdesc'/>",
        editable: false,
        visible: true,
        width : 180,
        style: "aui-grid-user-custom-left"
   }
   ,{
        dataField: "locType",
        headerText: "<spring:message code='log.head.locationtype'/>",
        editable: false,
        visible: true,
        width : 120
   }
  ,{
       dataField: "locStusName",
       headerText: "<spring:message code='log.head.locationStatus'/>",
       editable: false,
       visible: true,
       width : 120
   }
  ,{
       dataField: "docStusName",
       headerText: "<spring:message code='log.head.docStatus'/>",
       editable: false,
       visible: true,
       width : 150
   }
  ,{
       dataField: "docStartDt",
       headerText: "<spring:message code='log.head.stockAuditDateFrom'/>",
       width : 170,
       editable: false,
       visible: true,
       dataType: "date",
       formatString: "dd/mm/yyyy"
   }
  ,{
      dataField: "docEndDt",
      headerText: "<spring:message code='log.head.stockAuditDateTo'/>",
      width : 150,
      editable: false,
      visible: true,
      dataType: "date",
      formatString: "dd/mm/yyyy"
  }
  ,{
      dataField: "locStkGrad",
      headerText: "<spring:message code='log.head.locationgrade'/>",
      editable: false,
      visible: true,
      width : 110
  }
  ,{
      dataField: "docLocTypeNm",
      headerText: "<spring:message code='log.head.docLocationType'/>",
      editable: false,
      visible: true,
      width : 160,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "ctgryTypeNm",
      headerText: "<spring:message code='log.head.categoryType'/>",
      editable: false,
      visible: true,
      width : 200,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "itmTypeNm",
      headerText: "<spring:message code='log.head.itemtype'/>",
      editable: false,
      visible: true,
      width : 120,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "stockAuditReason",
      headerText: "<spring:message code='log.head.stockAuditReason'/>",
      editable: false,
      visible: true,
      width : 200,
      style: "aui-grid-user-custom-left"
  }
  ,{
     dataField: "rem",
     headerText: "<spring:message code='log.head.remark'/>",
     editable: false,
     visible: true,
     width : 200,
     style: "aui-grid-user-custom-left"
  }
  ,{
     dataField: "updUserNm",
     headerText: "<spring:message code='log.head.createuser'/>",
     width : 110,
     editable: false,
     visible: true,
     style: "aui-grid-user-custom-left"
  }
  ,{
     dataField: "updDt",
     headerText: "<spring:message code='log.head.createdate'/>",
     width : 90,
     editable: false,
     visible: true,
     dataType: "date",
     formatString: "dd/mm/yyyy"
  }
  ,{
      dataField: "appv1ReqstUserNm",
      headerText: "<spring:message code='approveView.requester'/>",
      editable: false,
      visible: true,
      width : 120,
      style: "aui-grid-user-custom-left"
   }
   ,{
      dataField: "appv1ReqstDt",
      headerText: "<spring:message code='log.head.requestdate'/>",
      width : 140,
      editable: false,
      visible: true,
      dataType: "date",
      formatString: "dd/mm/yyyy"
   }
   ,{
       dataField: "appv1UserNm",
       headerText: "<spring:message code='log.head.1stApprover'/>",
       editable: false,
       visible: true,
       width : 120,
       style: "aui-grid-user-custom-left"
   }
   ,{
      dataField: "appv1Dt",
      headerText: "<spring:message code='log.head.1stApprovaldate'/>",
      width : 140,
      editable: false,
      visible: true,
      dataType: "date",
      formatString: "dd/mm/yyyy"
   }
   ,{
       dataField: "appv1Opinion",
       headerText: "<spring:message code='log.head.1stOpinion'/>",
       editable: false,
       visible: true,
       width : 300,
       style: "aui-grid-user-custom-left"
   }
   ,{
       dataField: "appv2UserNm",
       headerText: "<spring:message code='log.head.2ndApprover'/>",
       editable: false,
       visible: true,
       width : 120,
       style: "aui-grid-user-custom-left"
   }
   ,{
      dataField: "appv2Dt",
      headerText: "<spring:message code='log.head.2ndApprovaldate'/>",
      width : 140,
      editable: false,
      visible: true,
      dataType: "date",
      formatString: "dd/mm/yyyy"
   }
   ,{
       dataField: "appv2Opinion",
       headerText: "<spring:message code='log.head.2ndOpinion'/>",
       editable: false,
       visible: true,
       width : 300,
       style: "aui-grid-user-custom-left"
   }
];

    // 그리드 속성 설정
    var gridPros = {
        // 페이징 사용
        usePaging: false,
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        //pageRowCount: 20,
        editable: false,
        fixedColumnCount: 0,
        headerHeight: 30,
        enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
        selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
        useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
        enableFilter : true,             // 필터 사용 여부 (기본값 : false)
        useGroupingPanel : false,    // 그룹핑 패널 사용
        showStateColumn : false,      // 상태 칼럼 사용
        enableSorting : false,
        showRowCheckColumn : true,    // row checkbox
        rowCheckToRadio : true,
        enableRestore: true
    };

    $(document).ready(function () {

        myGridID = GridCommon.createAUIGrid("grid_main_list", columnLayout,'',gridPros);
        myExcelGridID = GridCommon.createAUIGrid("grid_excel_list", columnLayout,'',gridPros);

        // main grid paging
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(myExcelGridID, []);

        //CommonCombo.make('listLocType', '/common/selectCodeList.do', {groupCode : 339} , '', {id:'code', type: 'M'}, 'f_multiCombo');
        //CommonCombo.make('listCatType', '/common/selectCodeList.do', {groupCode : 11} , '', {id:'code', type: 'M'});
        doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'},  '${defLocType}', 'listLocType', 'M','f_multiCombo');
        CommonCombo.make('locStatus', '/common/selectCodeList.do', {groupCode : 437, orderValue: "CODE"} , '', {type: 'S'});
        doGetComboSepa('/common/selectBranchCodeList.do', '3', ' - ', '', 'branchId', 'M', 'f_multiCombo');

        // header Click
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.

            var span = $(myGridID).find(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
            if(mSort.hasOwnProperty(event.dataField)){
                if(mSort[event.dataField].dir == "asc"){
                    mSort[event.dataField] = {"field":event.dataField, "dir":"desc" };
                    $(span).removeClass("aui-grid-sorting-ascending");
                    $(span).addClass("aui-grid-sorting-descending");
                }else{
                    delete mSort[event.dataField];
                    $(span).removeClass("aui-grid-sorting-descending");
                }
            }else{
                mSort[event.dataField] = {"field":event.dataField, "dir":"asc"};
                $(span).addClass("aui-grid-sorting-ascending");
            }

            getListAjax(1);
       });

        AUIGrid.bind(myGridID, "cellDoubleClick", function (event) {
            fn_countStockAuditRegisterPop(event.item.stockAuditNo, event.item.whLocId, 'DET');
        });

        //excel Download
        $('#excelDown').click(function() {
           GridCommon.exportTo("grid_excel_list", 'xlsx', "Count - Stock Audit List");
        });

        $('#search').click(function() {
            getListAjax(1)
        });

        $("#create").click(function(){
            var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

            if(checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
            } else if (checkedItems.length > 1) {
            	 Common.alert('Only One select.');
                 return false;
            } else{
            	for (var i = 0, len = checkedItems.length; i < len; i++) {
                    stockAuditNo = checkedItems[i].stockAuditNo;
                    whLocId = checkedItems[i].whLocId;
                    docStusCodeId = checkedItems[i].docStusCodeId;
                    locStusCodeId = checkedItems[i].locStusCodeId;
                }
            	// Doc Status(5679 : Start Audit),  Loc Status(5685 : Unregisterd, 5686 : Save, 5689 : 1st Reject, 5691 :2nd Reject, 5713 : 3rd Reject)
            	if((docStusCodeId == '5679' && locStusCodeId == '5685')
            			|| locStusCodeId == '5686' || locStusCodeId == '5689' || locStusCodeId == '5691' || locStusCodeId == '5713'){
            		fn_countStockAuditRegisterPop(stockAuditNo, whLocId, 'REG');
            	} else {
            		Common.alert('Please check the status.');
                    return false;
            	}
            }
        });

        $("#approve1st").click(function(){
            var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

            if(checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
            } else if (checkedItems.length > 1) {
                 Common.alert('Only One select.');
                 return false;
            } else{
                for (var i = 0, len = checkedItems.length; i < len; i++) {
                    stockAuditNo = checkedItems[i].stockAuditNo;
                    whLocId = checkedItems[i].whLocId;
                    docStusCodeId = checkedItems[i].docStusCodeId;
                    locStusCodeId = checkedItems[i].locStusCodeId;
                }
                // Loc Status(5687 : Request approval)
                if(locStusCodeId == '5687'){
                    fn_countStockAuditRegisterPop(stockAuditNo, whLocId, 'APPR');
                } else {
                    Common.alert('Only in the [Request approval] status.');
                    return false;
                }
            }
        });
    });

    function f_multiCombo() {
        $(function() {
        	$(function() {
                $('#branchId').change(function() {

                }).multipleSelect( {
                        selectAll : true
                });
            });

            $('#listLocType').change(function() {
                if ($('#listLocType').val() != null && $('#listLocType').val() != "" ){
                    var searchlocgb = $('#listLocType').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     //doGetComboData('/common/selectStockLocationList2.do', param , '${defLocCode}' , 'locCode', 'M','f_multiComboType');
                     CommonCombo.make('locCode', '/common/selectStockLocationList2.do', param , '${defLocCode}', {type: 'M', id:'codeId', name:'codeName', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function f_multiComboType() {
        $(function() {
            $('#locCode').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function fn_countStockAuditRegisterPop(stockAuditNo, whLocId, action) {
        var data = {
                stockAuditNo: stockAuditNo,
                whLocId: whLocId,
                action: action,
        };

        Common.popupDiv("/logistics/adjustment/countStockAuditRegisterPop.do", data, null, true, "countStockAuditRegisterPop");
    }


    function getListAjax(goPage) {
    	if(FormUtil.checkReqValue($("#stockAuditNo"))) {
            if(FormUtil.checkReqValue($("#docStartDt")) && FormUtil.checkReqValue($("#docEndDt"))){
                Common.alert("<spring:message code='log.alert.inputStockAuditDate'/>");
                return;
            }
        }

        var locCodeVal = $("#locCode option:selected").val();

    	if( FormUtil.isEmpty(locCodeVal)) {
           var arg = "<spring:message code='log.head.locationcode' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
        }

    	var url = "/logistics/adjustment/selectCountStockAuditList.do";

        var param = $("#searchForm").serializeJSON();

        var sortList = [];
        $.each(mSort, function(idx, row){
            sortList.push(row);
        });

        param = $.extend(param, {"rowCount":20, "goPage":goPage}, {"sort":sortList});

        // 초기화
        AUIGrid.setGridData(myGridID, []);

        Common.ajax("POST" , url , param, function(result){
        	GridCommon.createExtPagingNavigator(goPage, result.total, {funcName:'getListAjax', rowCount:20 });
            AUIGrid.setGridData(myGridID, result.data.list);
            AUIGrid.setGridData(myExcelGridID, result.data.excelList);
        });
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Count-Stock Audit</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li id="approve1st"><p class="btn_blue"><a id="approve1st">1st Approve</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li id="create"><p class="btn_blue"><a id="create">Result registration</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li  id="search"><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" method="post" onsubmit="return false;">
            <!-- table start -->
            <table class="type1">

                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='log.head.stockAuditDate'/><span class="must">*</span></th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="docStartDt" name="docStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" readonly/></p>
                        <span>To</span>
                        <p><input id="docEndDt" name="docEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" readonly/></p>
                        </div><!-- date_set end -->
                    </td>

                    <th scope="row"><spring:message code='log.head.stockauditno'/></th>
                    <td>
                        <input id="stockAuditNo" name="stockAuditNo" type="text"  placeholder="" class="w100p" />
                    </td>
                    <th scope="row"><spring:message code='log.head.locationStatus'/></th>
                    <td>
                        <select class="w100p" id="locStatus" name="locStatus">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='log.head.locationtype'/></th>
                    <td>
                        <select id="listLocType" name="listLocType[]" class="multy_select w100p" multiple="multiple">
                        </select>
                    </td>
                    <th scope="row"><spring:message code='log.head.locationcode'/><span class="must">*</span></th>
                    <td>
                        <select class="w100p" id="locCode" name="locCode[]"><option value="">Choose One</option></select>
                    </td>
                    <th scope="row">Branch</th>
                    <td>
                         <select id="branchId" name="branchId[]" class="multy_select w100p" multiple="multiple"></select>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
                <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code='sys.btn.excel.dw'/></a></p></li>
            </c:if>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_main_list" style="width:100%; height:90%; margin:0 auto;" class="autoGridHeight"></div>
            <div id="grid_excel_list" style="height:0px;display:none"></div>
            <!-- grid paging navigator -->
            <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel autoFixArea"></div>

        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->

