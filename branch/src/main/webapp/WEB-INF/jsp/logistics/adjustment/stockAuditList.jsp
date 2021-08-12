<!--=================================================================================================
* Task  : Logistics
* File Name : stockAuditList.jsp
* Description : Stock Audit List
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
    var detailGridID;
    var mSort = {};

    // AUIGrid 칼럼 설정
    var columnLayout = [
    {
       dataField : "stockAuditNo",
       headerText : "<spring:message code='log.head.stockauditno'/>",
       editable : false,
       visible: true,
       width : 130,
       style : "aui-grid-link-renderer",
       // LinkRenderer 를 활용하여 javascript 함수 호출로 사용하고자 하는 경우
       renderer :
          {
             type : "LinkRenderer",
             baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
             // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
             jsCallback : function(rowIndex, columnIndex, value, item)
             {
               fn_locDetailList(rowIndex, value);
             }
          }
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
       width : 160,
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
      width : 120
  }
 ,{
      dataField: "locTypeNm",
      headerText: "<spring:message code='log.head.locationtype'/>",
      editable: false,
      visible: true,
      width : 120,
      style: "aui-grid-user-custom-left"
  }
 ,{
      dataField: "locCount",
      headerText: "<spring:message code='log.head.locationCount'/>",
      width : 110,
      editable: false,
      visible: true,
      dataType:"numeric",
      formatString:"#,##0",
      style: "aui-grid-user-custom-right"
  }
  ,{
      dataField: "ctgryTypeNm",
      headerText: "<spring:message code='log.head.categoryType'/>",
      editable: false,
      visible: true,
      width : 150,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "itmTypeNm",
      headerText: "<spring:message code='log.head.itemtype'/>",
      editable: false,
      visible: true,
      width : 150,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "serialChkYn",
      headerText: "<spring:message code='log.head.serialcheck'/>",
      editable: false,
      visible: true,
      width : 100
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
     dataField: "crtUserNm",
     headerText: "<spring:message code='log.head.createuser'/>",
     width : 120,
     editable: false,
     visible: true,
     style: "aui-grid-user-custom-left"
  }
  ,{
     dataField: "crtDt",
     headerText: "<spring:message code='log.head.createdate'/>",
     width : 90,
     editable: false,
     visible: true,
     dataType: "date",
     formatString: "dd/mm/yyyy"
  }
  ,{
     dataField: "appv3ReqstUserNm",
     headerText: "<spring:message code='log.head.3rdRequester'/>",
     editable: false,
     visible: true,
     width : 120,
     style: "aui-grid-user-custom-left"
  }
  ,{
     dataField: "appv3ReqstDt",
     headerText: "<spring:message code='log.head.3rdRequestdate'/>",
     width : 140,
     editable: false,
     visible: true,
     dataType: "date",
     formatString: "dd/mm/yyyy"
  }
 ,{
      dataField: "appvAtchFileGrpId",
      headerText: "<spring:message code='log.head.groupwareAppAttFile'/>",
      editable: false,
      visible: false,
      width : 140,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "reuploadYn",
      headerText: "<spring:message code='log.head.groupwareAppAttFileReUpload'/>",
      editable: false,
      visible: true,
      width : 180
  }
  ,{
      dataField: "appv3ReqstOpinion",
      headerText: "<spring:message code='log.head.3rdRequestapprovalOpinion'/>",
      editable: false,
      visible: true,
      width : 300,
      style: "aui-grid-user-custom-left"
  }
  ,{
      dataField: "appv3UserNm",
      headerText: "<spring:message code='log.head.3rdApprover'/>",
      editable: false,
      visible: true,
      width : 120,
      style: "aui-grid-user-custom-left"
  }
  ,{
     dataField: "appv3Dt",
     headerText: "<spring:message code='log.head.3rdApprovaldate'/>",
     width : 130,
     editable: false,
     visible: true,
     dataType: "date",
     formatString: "dd/mm/yyyy"
  }
  ,{
      dataField: "appv3Opinion",
      headerText: "<spring:message code='log.head.3rdOpinion'/>",
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
        showStateColumn : false,   // 상태 칼럼 사용
        enableSorting : false,
        rowCheckToRadio : true,     // 체크박스 대신 라디오버튼 출력함
        showRowCheckColumn : true    // row checkbox
    };

    var detailColumnLayout = [
    {
       dataField: "locType",
       headerText: "<spring:message code='log.head.locationtype'/>",
       editable: false,
       visible: true,
       width : 200
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
        dataField: "locStusName",
        headerText: "<spring:message code='log.head.locationStatus'/>",
        editable: false,
        visible: true,
        width : 120
    }
    ,{
        dataField: "updUserNm",
        headerText: "<spring:message code='log.head.createuser'/>",
        width : 120,
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
         width : 100,
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
    var detailGridPros = {
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
        showRowCheckColumn : false,    // row checkbox
        enableRestore: true
    };

    $(document).ready(function () {

        myGridID = GridCommon.createAUIGrid("grid_main_list", columnLayout,'',gridPros);
        myExcelGridID = GridCommon.createAUIGrid("grid_excel_list", columnLayout,'',gridPros);
        detailGridID = GridCommon.createAUIGrid("grid_sub_list", detailColumnLayout,'',detailGridPros);

        // Grid Init
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(myExcelGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        // main grid paging
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        //CommonCombo.make('listLocType', '/common/selectCodeList.do', {groupCode : 339} , '', {id:'code', type: 'M'});
        doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'listLocType', 'M','f_multiCombo');
        CommonCombo.make('docStatus', '/common/selectCodeList.do', {groupCode : 436, orderValue: "CODE"} , '', {type: 'S'});

        AUIGrid.bind(detailGridID, "cellDoubleClick", function (event) {
            fn_countStockAuditDetailPop(event.item.stockAuditNo, event.item.whLocId, 'DET');
        });

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

        AUIGrid.bind(myGridID, "rowCheckClick", function( event ) {
            var stockAuditNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "stockAuditNo");
            var subParam = {"stockAuditNo":stockAuditNo};

            Common.ajax("GET", "/logistics/adjustment/selectStockAuditDetailList.do"
                    , subParam
                    , function(result){
                           console.log("data : " + result);
                           AUIGrid.setGridData(detailGridID, result.dataList);
            });
      });

        // cellClick event.
        AUIGrid.bind(myGridID, "cellClick", function( event )
        {
        	var stockAuditNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "stockAuditNo");
        	AUIGrid.setCheckedRowsByValue(myGridID, "stockAuditNo", stockAuditNo);
            var subParam = {"stockAuditNo":stockAuditNo};

            Common.ajax("GET", "/logistics/adjustment/selectStockAuditDetailList.do"
                    , subParam
                    , function(result){
                           console.log("data : " + result);
                           AUIGrid.setGridData(detailGridID, result.dataList);
            });
        });

        //excel Download
        $('#excelDown').click(function() {
           GridCommon.exportTo("grid_excel_list", 'xlsx', "Stock Audit List");
        });

        $('#search').click(function() {
            getListAjax(1);
        });

        $('#create').click(function() {
        	fn_stockAuditRegisterPop('', 'REG');
        });

        $("#approve2nd").click(function(){
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
                    docStusCodeId = checkedItems[i].docStusCodeId;
                }
                // Doc Status(5679 : Start Audit),  Loc Status(5688 : 1st Approve, 5690 : 2nd Approve)
                var appr2Cnt = 0;
                var length = AUIGrid.getGridData(detailGridID).length;
                if(length > 0) {
                   for(var i = 0; i < length; i++) {
                       if(docStusCodeId == '5679' && (AUIGrid.getCellValue(detailGridID, i, "locStusCodeId") == '5688' || AUIGrid.getCellValue(detailGridID, i, "locStusCodeId") == '5690')) {
                           appr2Cnt ++;
                       }
                   }
                }

                if(appr2Cnt > 0) {
                	fn_stockAduitApprovePop(stockAuditNo, 'APPR2');
                } else {
                    Common.alert('Please check the status.');
                    return false;
                }
            }
        });

        $("#approve3rd").click(function(){
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
                    docStusCodeId = checkedItems[i].docStusCodeId;
                }
                // Doc Status(5680 : 3rd Request approval)
                if(docStusCodeId == '5680') {
                    fn_stockAduitApprovePop(stockAuditNo, 'APPR3');
                } else {
                   Common.alert('Only in the [3rd Request approval] status.');
                   return false;
                }
            }
        });

        $("#otherGiGr").click(function(){
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
                    docStusCodeId = checkedItems[i].docStusCodeId;
                }
                // Doc Status(5681 : 3rd Approve)
                if(docStusCodeId == '5681') {
                    fn_stockAduitOtherPop(stockAuditNo, 'REG');
                } else {
                    Common.alert('Only in the [3rd Approve] status.');
                    return false;
                }
            }
        });
    });

    function f_multiCombo() {
        $(function() {
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
                     doGetComboData('/common/selectStockLocationList2.do', param , '', 'locCode', 'M','f_multiComboType');
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

    function fn_locDetailList(rowIndex, stockAuditNo) {
    	var stusVal = AUIGrid.getCellValue(myGridID, rowIndex, "docStusCodeId")
    	if(stusVal == '5678')  { //  Doc Status(5678 : Save)
            fn_stockAuditRegisterPop(stockAuditNo, 'MOD');
        } else {
            fn_stockAuditRegisterPop(stockAuditNo, 'DET');
        }
    }

    function fn_stockAuditRegisterPop(stockAuditNo, action) {
        var data = {
                stockAuditNo: stockAuditNo,
                action: action,
        };

        if(action == 'DET') {
            Common.popupDiv("/logistics/adjustment/stockAuditDetailPop.do", data, null, true, "stockAuditDetailPop");
        } else {
        	Common.popupDiv("/logistics/adjustment/stockAuditRegisterPop.do", data, null, true, "stockAuditRegisterPop");
        }
    }

    function fn_countStockAuditDetailPop(stockAuditNo, whLocId, action) {
        var data = {
                stockAuditNo: stockAuditNo,
                whLocId: whLocId,
                action: action,
        };

        Common.popupDiv("/logistics/adjustment/countStockAuditRegisterPop.do", data, null, true, "countStockAuditRegisterPop");
    }

    function fn_stockAduitApprovePop(stockAuditNo, action) {
        var data = {
                stockAuditNo: stockAuditNo,
                action: action,
        };

        Common.popupDiv("/logistics/adjustment/stockAuditApprovePop.do", data, null, true, "stockAuditApprovePop");
    }

    function fn_stockAduitOtherPop(stockAuditNo, action) {
        var data = {
                stockAuditNo: stockAuditNo,
                action: action,
        };

        Common.popupDiv("/logistics/adjustment/stockAuditOtherPop.do", data, null, true, "stockAuditOtherPop");
    }

    // 그리드 조회
    function getListAjax(goPage) {

        if(FormUtil.checkReqValue($("#stockAuditNo"))) {
            if(FormUtil.checkReqValue($("#docStartDt")) && FormUtil.checkReqValue($("#docEndDt"))){
                Common.alert("<spring:message code='log.alert.inputStockAuditDate'/>");
                return;
            }
        }

    	var url = "/logistics/adjustment/selectStockAuditList.do";

        var param = $("#searchForm").serializeJSON();

        var sortList = [];
        $.each(mSort, function(idx, row){
            sortList.push(row);
        });

        param = $.extend(param, {"rowCount":20, "goPage":goPage}, {"sort":sortList});

        // 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(myExcelGridID, []);

        Common.ajax("POST" , url , param, function(result){
        	GridCommon.createExtPagingNavigator(goPage, result.total, {funcName:'getListAjax', rowCount:20 });
            AUIGrid.setGridData(myGridID, result.data.list);
            AUIGrid.setGridData(myExcelGridID, result.data.excelList);
            AUIGrid.setGridData(detailGridID, []);
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

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Stock Audit</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li id="approve2nd"><p class="btn_blue"><a id="approve2nd">2nd Approve</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li id="approve3rd"><p class="btn_blue"><a id="approve3rd">3rd Approve</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
            <li id="otherGiGr"><p class="btn_blue"><a id="otherGiGr">New Other GI / GR</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
            <li id="create"><p class="btn_blue"><a id="create">Create</a></p></li>
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
                        <p><input id="docStartDt" name="docStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  readonly /></p>
                        <span>To</span>
                        <p><input id="docEndDt" name="docEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                        </div><!-- date_set end -->
                    </td>

				    <th scope="row"><spring:message code='log.head.stockauditno'/></th>
                    <td>
                        <input id="stockAuditNo" name="stockAuditNo" type="text"  placeholder="" class="w100p" />
                    </td>
                    <th scope="row"><spring:message code='log.head.docStatus'/></th>
                    <td>
                        <select class="w100p" id="docStatus" name="docStatus">
                        </select>
                    </td>
				</tr>
				<tr>
				     <th scope="row"><spring:message code='log.head.locationtype'/></th>
                    <td>
                        <select id="listLocType" name="listLocType[]" class="multy_select w100p" multiple="multiple">
                        </select>
                    </td>
                    <th scope="row"><spring:message code='log.head.locationcode'/></th>
                    <td>
                        <select class="w100p" id="locCode" name="locCode[]"></select>
                    </td>

                    <th scope="row"></th>
                    <td>
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
            <div id="grid_main_list" style="height:280px;"></div>
            <!-- grid paging navigator -->
            <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
            <div id="grid_excel_list" style="height:0px;display:none"></div>
        </article><!-- grid_wrap end -->

        <aside class="title_line"><!-- title_line start -->
	       <h3>Stock Audit Location Detail</h3>
	    </aside><!-- title_line end -->
	    <article class="grid_wrap" ><!-- grid_wrap start -->
	      <!--  그리드 영역2  -->
	      <div id="grid_sub_list" class="autoGridHeight"></div>
	    </article><!-- grid_wrap end -->
    </section><!-- search_result end -->

</section>
<!-- content end -->

