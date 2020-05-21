<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">
/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}
</style>

<script type="text/javaScript">

var oldPoNo = -1;

var cdcDs = [];
<c:forEach var="obj" items="${cdcList}">
  cdcDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", address:"${obj.address}", telNo:"${obj.telNo}"});
</c:forEach>

var vendorDs = [];
var vendorObj = {};
<c:forEach var="obj" items="${vendorList}">
  vendorDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
  vendorObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

// main grid
var mSort = {};

    //AUIGrid 생성 후 반환 ID
    var myGridID, detailGridID, groupGridId;

    var gColumnLayout = [{dataField:"rnum", headerText:"No", width:50, editable:false}
		    , {dataField:"poNo", headerText:"PO No", width:120}
		    , {dataField:"cdc", visible:false, editable:false}
		    , {dataField:"cdcNm",headerText :"CDC NAME", width:180, editable:false}
		    , {dataField:"memAccId", headerText:"Supplier ID", width:120}
            , {dataField:"memAccName", headerText:"Supplier Name", width:250, editable:false}
		    , {dataField:"confirmQty", headerText:"PO QTY", width:120
		        , style:"aui-grid-user-custom-right"
		        , dataType:"numeric"
		        , formatString:"#,##0"
		    }
		    , {dataField:"actualQty", headerText:"Production Qty", width:120
		        , style:"aui-grid-user-custom-right"
		        , dataType:"numeric"
		        , formatString:"#,##0"
		    }
		    , {dataField:"delvryQty", headerText:"Delivery QTY", width:120
		        , style:"aui-grid-user-custom-right"
		        , dataType:"numeric"
		        , formatString:"#,##0"
		    }
		    , {dataField:"giQty", headerText:"GI QTY", width:120
		        , style:"aui-grid-user-custom-right"
		        , dataType:"numeric"
		        , formatString:"#,##0"
		    }
		    , {dataField:"grQty", headerText:"GR QTY", width:120
		        , style:"aui-grid-user-custom-right"
		        , dataType:"numeric"
		        , formatString:"#,##0"
		    }
		    , {dataField:"failQty", headerText:"Fail QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
	];

    var grid_gOptions = {
            usePaging : false,           // 페이지 설정1
            editable : false,            // 편집 가능 여부 (기본값 : false)
            enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
            selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
            showRowNumColumn : false,     // 그리드 넘버링
            enableFilter : true,         // 필터 사용 여부 (기본값 : false)
            showStateColumn : false,      // 상태 칼럼 사용
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
            groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
            rowIdField : "rnum",
            enableSorting : false,
            showRowCheckColumn : false,      // row 체크박스 표시 설정
            showRowAllCheckBox : false,      // 전체 체크박스 표시 설정
            showFooter : true,
            enableRestore: true
      };

    // 푸터 설정
    var gFooterLayout = [{labelText : "Total", positionField : "memAccName"}
                       , {dataField : "confirmQty"
                           , positionField : "confirmQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "actualQty"
                           , positionField : "actualQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "delvryQty"
                           , positionField : "delvryQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "giQty"
                           , positionField : "giQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "grQty"
                           , positionField : "grQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "failQty"
                           , positionField : "failQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
    ];

    // AUIGrid main 칼럼 설정
    var columnLayout = [ //{dataField:"rnum", headerText:"No", width:50, editable:false},
              {dataField:"poNo", headerText:"PO No", width:120}
            , {dataField:"poDtlNo", headerText:"PO Detail No", width:120}
            , {dataField:"stockId", visible:false}
            , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
            , {dataField:"stockName", headerText:"Material Name", width:300, editable:false, style:"aui-grid-user-custom-left"}
            , {dataField:"suppStsCode", visible:false}
            , {dataField:"suppStsName",headerText :"Sales Order", width:100, editable:false}
            , {dataField:"confirmQty", headerText:"PO QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"actualQty", headerText:"Production Qty", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"delvryQty", headerText:"Delivery QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"giQty", headerText:"GI QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"grQty", headerText:"GR QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"failQty", headerText:"Fail QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"apprDt", headerText:"PO Date", width:100, editable:false
                , dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"memAccId", headerText:"Supplier ID", width:120}
            , {dataField:"memAccName", headerText:"Supplier Name", width:250, editable:false}
    ];

    // main 그리드 속성 설정
    var grid_options = {
            usePaging : true,            // 페이지 설정1
            pageRowCount : 30,           // 페이지 설정2
            fixedColumnCount : 0,        // 틀고정(index)
            editable : false,            // 편집 가능 여부 (기본값 : false)
            enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
            selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
            showRowNumColumn : true,     // 그리드 넘버링
            enableFilter : true,         // 필터 사용 여부 (기본값 : false)
            useGroupingPanel : false,    // 그룹핑 패널 사용
            displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
            showStateColumn : false,      // 상태 칼럼 사용
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
            groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
            //rowIdField : "priceSeqNo",
            showFooter : true,
            enableSorting : true
    };

    // 푸터 설정
    var myFooterLayout = [{labelText : "Total", positionField : "stockName"}
                       , {dataField : "confirmQty"
                           , positionField : "confirmQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "actualQty"
                           , positionField : "actualQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "delvryQty"
                           , positionField : "delvryQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "giQty"
                           , positionField : "giQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "grQty"
                           , positionField : "grQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "failQty"
                           , positionField : "failQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
    ];

  // sub 칼럼 설정
  var subColumnLayout = [ {dataField:"hmcDelvryNo", headerText:"Delivery No", width:140, editable:false}
              , {dataField:"hmcDelvryNoDtlNo", headerText:"Delivery Detail No", width:140, editable:false}
              , {dataField:"poNo", headerText:"PO No", width:140, editable:false}
              , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
              , {dataField:"confirmQty", headerText:"PO QTY", width:100
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"delvryQty", headerText:"Delivery QTY", width:100
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"giQty", headerText:"GI QTY", width:100
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"grQty", headerText:"GR QTY", width:100
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"grFailQty", headerText:"GR Fail QTY", width:100
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"stockId", visible:false}
              , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
              , {dataField:"stockName", headerText:"Material Name", width:350, editable:false, style:"aui-grid-user-custom-left"}
              , {dataField:"memAccId", headerText:"Supplier ID", width:120}
              , {dataField:"memAccName", headerText:"Supplier Name", width:250, editable:false}
              , {dataField:"delvryDt", headerText:"Delivery Date", width:140
                  , dataType:"date"
                  , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                  , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
              }
              , {dataField:"delvryGiDt", headerText:"DELVRY GI DT", width:140
                  , dataType:"date"
                  , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                  , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
              }
  ];

    // sub 그리드 속성 설정
    var subGrid_options = {
	    usePaging : true,            // 페이지 설정1
	    pageRowCount : 30,           // 페이지 설정2
	    fixedColumnCount : 0,        // 틀고정(index)
	    editable : false,            // 편집 가능 여부 (기본값 : false)
	    enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	    selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
	    showRowNumColumn : true,     // 그리드 넘버링
	    enableFilter : true,         // 필터 사용 여부 (기본값 : false)
	    useGroupingPanel : false,    // 그룹핑 패널 사용
	    displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	    showStateColumn : false,      // 상태 칼럼 사용
	    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
	    groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
	    //rowIdField : "priceSeqNo",
	    showFooter : true,
	    enableSorting : true
    };

    var subFooterLayout = [{labelText : "Total", positionField : "poDtlNo"}
	    , {dataField : "confirmQty"
	        , positionField : "confirmQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
	    , {dataField : "delvryQty"
	        , positionField : "delvryQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
	    , {dataField : "giQty"
	        , positionField : "giQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
	    , {dataField : "grQty"
	        , positionField : "grQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
	    , {dataField : "grFailQty"
	        , positionField : "grFailQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
    ];


    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        groupGridId = GridCommon.createAUIGrid("groupGrid", gColumnLayout, "", grid_gOptions);
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);
        detailGridID = GridCommon.createAUIGrid("detailGrid", subColumnLayout, "", subGrid_options);

        AUIGrid.setFooter(groupGridId, gFooterLayout);
        AUIGrid.setFooter(myGridID, myFooterLayout);
        AUIGrid.setFooter(detailGridID, subFooterLayout);


        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getGroupListAjax', targetId:'group_grid_paging'});

        //GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(groupGridId, []);
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        // combo 내역 초기화
        doDefCombo(cdcDs, '', 'sCdc', 'S', '');
        doDefCombo(vendorDs, '', 'sMemAccId', 'S', '');

        if( js.String.isEmpty($("#sPoDtFrom").val()) ){
            $("#sPoDtFrom").val("${threeMonthBf}");
        }
        if( js.String.isEmpty($("#sPoDtTo").val()) ){
            $("#sPoDtTo").val("${toDay}");
        }

        <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}">
	        if(js.String.isEmpty("${zMemAccId}")){
	            $("#sMemAcc").val("N");
	        }
	        $("#sMemAccId").val("${zMemAccId}");
	        //$("select[name=sMemAccId]").prop('disabled',true);
	    </c:if>

	    // 조회버튼
        $("#btnSearch").click(function(){
            if(js.String.isEmpty($("#sCdc").val()) || js.String.isEmpty($("#sMemAccId").val())){
                Common.alert("Please, check the mandatory value.");
                return ;
            }

		    // 날짜형식 체크
		    var sValidDtFrom = $("#sPoDtFrom").val();
		    var sValidDtTo = $("#sPoDtTo").val();

		    var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
		    if( !date_pattern.test(sValidDtFrom)) {
		          Common.alert("Please check the date format.");
		          return ;
		    }
		    if( !date_pattern.test(sValidDtTo)) {
		        Common.alert("Please check the date format.");
		        return ;
		    }

            var arrStDt = sValidDtFrom.split('/');
            var arrEnDt = sValidDtTo.split('/');
            var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
            var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);

            var diff = dat2 - dat1;
            if(diff < 0){
            	Common.alert("The start date can be greater than the end date.");
            	return ;
            }

            if(js.date.dateDiff(dat1, dat2) > 92){
            	Common.alert("The duration is only three months.");
                return ;
            }

		    // 메인 그리드 조회
		    //getListAjax(1);
            getGroupListAjax(1);

          });

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });
    });

    // 이벤트 정의
    $(function(){

    	AUIGrid.bind(groupGridId, "cellClick", cellGroupClickEvent);

    	// header Click
        AUIGrid.bind(groupGridId, "headerClick", function( event ) {
            var span = $(groupGridId).find(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
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

            getGroupListAjax(1);
        });


        /*
        // main grid cellClick event.
        AUIGrid.bind(myGridID, "cellClick", cellClickEvent);

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
        */

    });


//--function--//

function cellGroupClickEvent( event ){
    //console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");

    // 그리드 선택 block을 잡아준다.
    //AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
     var poNo = AUIGrid.getCellValue(groupGridId, event.rowIndex, "poNo");
     if(poNo != oldPoNo){
    	 AUIGrid.setGridData(myGridID, []);
    	 AUIGrid.setGridData(detailGridID, []);

         if(js.String.isEmpty(poNo)){
           oldPoNo = poNo;
           return false;
         }

       var mainParam = {"sPoNo":poNo};
       Common.ajax("POST", "/homecare/report/hcPoResult/selecthcPoResultMainList.do"
               , mainParam
               , function(result){
                      //console.log("data : " + result);
                      AUIGrid.setGridData(myGridID, result.dataList);
       });


       var subParam = {"sPoNo":poNo};
       Common.ajax("GET", "/homecare/report/hcPoResult/selecthcPoResultSubList.do"
               , subParam
               , function(result){
                      //console.log("data : " + result);
                      AUIGrid.setGridData(detailGridID, result.dataList);
       });

    }
    oldPoNo = poNo;
}


/*
// main grid cellClick event.
function cellClickEvent( event ){
    //console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");

    // 그리드 선택 block을 잡아준다.
    //AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
     var poNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "poNo");
     if(poNo != oldPoNo){
       AUIGrid.setGridData(detailGridID, []);

       if(js.String.isEmpty(poNo)){
         oldPoNo = poNo;
         return false;
       }

       var subParam = {"sPoNo":poNo};
       Common.ajax("GET", "/homecare/report/hcPoResult/selecthcPoResultSubList.do"
               , subParam
               , function(result){
                      //console.log("data : " + result);
                      AUIGrid.setGridData(detailGridID, result.dataList);
       });

    }
    oldPoNo = poNo;
}
*/

function getGroupListAjax(goPage) {
    var url = "/homecare/report/hcPoResult/selecthcPoResultGroupList.do";

    var param = $("#searchForm").serializeObject();
    param.sMemAccId = $("#sMemAccId").val();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":25, "goPage":goPage}, {"sort":sortList});
    //console.log("param : ", param);

    // 초기화
    oldPoNo = -1;
    AUIGrid.setGridData(groupGridId, []);

    Common.ajax("POST" , url , param, function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getGroupListAjax', targetId:'group_grid_paging'});

        AUIGrid.setGridData(groupGridId, data.dataList);
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        if(data.total > 0){
            // 행을 선택해줌.
            AUIGrid.setSelectionByIndex(groupGridId, 0);
            cellGroupClickEvent({"rowIndex":0, "columnIndex":0});
        }
    });

}


// 메인 그리드 조회
/*
function getListAjax(goPage) {
    var url = "/homecare/report/hcPoResult/selecthcPoResultMainList.do";

    var param = $("#searchForm").serializeObject();
    param.sMemAccId = $("#sMemAccId").val();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":25, "goPage":goPage}, {"sort":sortList});
    console.log("param : ", param);

    // 초기화
    oldPoNo = -1;
    AUIGrid.setGridData(myGridID, []);

    Common.ajax("POST" , url , param, function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, data.dataList);
        AUIGrid.setGridData(detailGridID, []);

        if(data.total > 0){
	        // 행을 선택해줌.
	        AUIGrid.setSelectionByIndex(myGridID, 0);
	        cellClickEvent({"rowIndex":0, "columnIndex":0});
        }
    });

}
*/

/**
* dd-mm-yyyy 날짜 형식을 체크함.
*/
function fn_isDateValidate(sValidDt){
  // 날짜형식 체크
    var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
    if( sValidDt != null && sValidDt != ""
        && !date_pattern.test(sValidDt)
    ) {
        return false;
    }
    return true;
}



</script>

<section id="content"><!-- content start -->
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Homecare</li>
    <li>Report</li>
  </ul>

  <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
    <h2>Po Result List</h2>

    <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
    </c:if>
    </ul>
  </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post" onsubmit="return false;">
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><span style="color:red">*</span>CDC</th>
                    <td>
                        <select id="sCdc" name="sCdc" placeholder="" class="w100p" >
                    </td>
                    <th scope="row"><span style="color:red">*</span>PO Date</th>
                    <td>
                        <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="sPoDtFrom" name="sPoDtFrom" type="text"
                                        title="PO start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="sPoDtTo" name="sPoDtTo" type="text"
                                        title="PO End Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                            </div>
                    </td>
                    <th scope="row"><span style="color:red">*</span>Supplier</th>
                    <td>
                        <select id="sMemAccId" name="sMemAccId" title="" placeholder="" class="w100p" >
                        <input type="hidden" id="sMemAcc" name="sMemAcc" />
                    </td>
                </tr>

                <tr>
                    <th scope="row">PO No</th>
                    <td>
                        <input type="text" id="sPoNo" name="sPoNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">Delivery No</th>
                    <td>
                        <input type="text" id="sHmcDelvryNo" name="sHmcDelvryNo" placeholder="" class="w100p" >
                    </td>
                    <td colspan="2"></td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

  <section class="search_result"><!-- search_result start -->

    <aside class="title_line"><!-- title_line start -->
        <h3>PO List</h3>
        <ul class="right_btns">
        </ul>
    </aside><!-- title_line end -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <!-- 그리드 영역1 -->
        <div id="groupGrid" style="height:250px;"></div>

        <!-- 그리드 페이징 네비게이터 -->
        <div id="group_grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
    </article><!-- grid_wrap end -->



	<aside class="title_line"><!-- title_line start -->
        <h3>PO Item List</h3>
	    <ul class="right_btns">
	    </ul>
	</aside><!-- title_line end -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <!-- 그리드 영역1 -->
        <div id="mainGrid" style="height:250px; margin:0 auto;"></div>
	    <!-- 그리드 페이징 네비게이터 -->
	    <!-- <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div> -->
    </article><!-- grid_wrap end -->


    <aside class="title_line"><!-- title_line start -->
        <h3>PO to Delivery List</h3>
    </aside><!-- title_line end -->
    <article class="grid_wrap" ><!-- grid_wrap start -->
        <!--  그리드 영역2  -->
        <div id="detailGrid" style="height:250px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

  </section><!-- search_result end -->

</section><!-- content end -->
