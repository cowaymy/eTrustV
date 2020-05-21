<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">
/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}

.aui-grid-user-custom {
    text-align:center;
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
    var myGridID, detailGridID, deliveryGridID;

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField:"rnum", headerText:"No", width:50, editable:false}
            , {dataField:"cdc", headerText:"CDC", width:120}
            , {dataField:"cdcName", headerText :"CDC Name", width:250, style:"aui-grid-user-custom-left"}
            , {dataField:"poNo", headerText:"PO No", width:160}
            , {dataField:"poTyCd", visible:false}
            , {dataField:"poTyName",headerText :"PO Type", width:120}
            , {dataField:"poStsCode", visible:false}
            , {dataField:"poStsName",headerText :"Status", width:100}
            , {dataField:"suppStsCd", visible:false}
            , {dataField:"suppStsCode", visible:false}
            , {dataField:"suppStsName",headerText :"Sales Order", width:100}
            , {dataField:"memAccId", headerText:"Supplier ID", width:120}
            , {dataField:"memAccName", headerText:"Supplier Name", width:250, style:"aui-grid-user-custom-left"}
            , {dataField:"poDt", headerText:"PO Date", width:100, editable:false
                , dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"cdcDueDt", headerText:"Delivery Due Date", width:140
                , dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"address", headerText:"Address", width:380, style:"aui-grid-user-custom-left"}
            , {dataField:"tel", headerText:"Contact No", width:120}
            , {dataField:"rm", headerText:"Remark", width:300, style:"aui-grid-user-custom-left"}
    ];

    // main 그리드 속성 설정
    var grid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      //fixedColumnCount : 1,        // 틀고정(index)
      editable : false,            // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      //showSelectionBorder:true,    // (녹색 테두리 선)(기본값 : true)
      //useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : false,     // 그리드 넘버링
      enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      //useGroupingPanel : false,    // 그룹핑 패널 사용
      //displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : false,      // 상태 칼럼 사용
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      rowIdField : "rnum",
      enableSorting : false,
      showRowCheckColumn : false,      // row 체크박스 표시 설정
      showRowAllCheckBox : false,      // 전체 체크박스 표시 설정
      enableRestore: true
    };

  // sub 칼럼 설정
  var subColumnLayout = [{dataField:"poNo", headerText:"PO No", width:160, editable:false}
              , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
              , {dataField:"stockId", visible:false}
              , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
              , {dataField:"stockName", headerText:"Material Name", width:350, editable:false, style:"aui-grid-user-custom-left"}
              , {dataField:"confirmQty", headerText:"PO QTY", width:100, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"actualQty", headerText:"Production Qty", width:140, editable:false
                  , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"extQty", headerText:"Delived Qty", width:110, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"qcFailQty", headerText:"QC Fail Qty", width:120, editable:false
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"availableQty", headerText:"Available Qty", width:120, editable:false
                  , style:"aui-grid-user-custom-right"
                  , dataType:"numeric"
                  , formatString:"#,##0"
              }
              , {dataField:"doQty", headerText:"DO Qyt", width:140, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
                    , editRenderer : {
                          type : "InputEditRenderer",
                          showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                          onlyNumeric : true, // 0~9만 입력가능
                          allowPoint : false, // 소수점( . ) 도 허용할지 여부
                          allowNegative : false, // 마이너스 부호(-) 허용 여부
                          textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                          autoThousandSeparator : false // 천단위 구분자 삽입 여부
                    }
              }
              , {dataField:"uomName", headerText:"UOM", width:100, editable:false}
              , {dataField:"poUprc", headerText:"PO Price", width:120, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"

              }
              , {dataField:"suplyPrc", headerText:"Supply Price", width:140, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"tax", headerText:"Tax", width:120, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
              , {dataField:"taxName", headerText:"Tax Text", width:100, editable:false}
              , {dataField:"total", headerText:"Total", width:140, editable:false
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"

              }
  ];

    // sub 그리드 속성 설정
    var subGrid_options = {
    usePaging : false,           // 페이지 설정1
    //pageRowCount : 30,         // 페이지 설정2
    fixedColumnCount : 0,        // 틀고정(index)
    editable : true,             // 편집 가능 여부 (기본값 : false)
    enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
    selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
    useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
    showRowNumColumn : true,     // 그리드 넘버링
    enableFilter : true,         // 필터 사용 여부 (기본값 : false)
    useGroupingPanel : false,    // 그룹핑 패널 사용
    displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
    showStateColumn : false,      // 상태 칼럼 사용
    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
    groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
    //rowIdField : "priceSeqNo",
    enableSorting : true,
    showRowCheckColumn : false,    // row checkbox
    showRowAllCheckBox : false,
    enableRestore: true,
    showFooter : true,
    softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    var subFooterLayout = [{labelText : "Total", positionField : "stockName"}
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
	    , {dataField : "extQty"
	        , positionField : "extQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
	    , {dataField : "qcFailQty"
	        , positionField : "qcFailQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
	    , {dataField : "availableQty"
	        , positionField : "availableQty"
	        , operation : "SUM"
	        , formatString : "#,##0"
	        , style:"aui-grid-user-custom-right"
	    }
       , {dataField : "doQty"
            , positionField : "doQty"
            , operation : "SUM"
            , formatString : "#,##0"
            , style:"aui-grid-user-custom-right"
        }
       , {dataField : "poUprc"
           , positionField : "poUprc"
           , operation : "SUM"
           , formatString : "#,##0.00"
           , style:"aui-grid-user-custom-right"
       }
       , {dataField : "suplyPrc"
           , positionField : "suplyPrc"
           , operation : "SUM"
           , formatString : "#,##0.00"
           , style:"aui-grid-user-custom-right"
       }
       , {dataField : "total"
           , positionField : "total"
           , operation : "SUM"
           , formatString : "#,##0.00"
           , style:"aui-grid-user-custom-right"
       }
	];


    // Delivery 칼럼 설정
    var deliveryColumnLayout = [{dataField:"rnum", visible:false}
                , {dataField:"hmcDelvryNo", headerText:"Delivery No", width:140, editable:false}
                , {dataField:"hmcDelvryNoDtlNo", headerText:"Delivery Detail No", width:140, editable:false}

                , {dataField:"stockId", visible:false}
                , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
                , {dataField:"stockName", headerText:"Material Name", width:350, editable:false, style:"aui-grid-user-custom-left"}

                , {dataField:"delvryQty", headerText:"Do QTY", width:100, editable:false
                    , style:"aui-grid-user-custom-right"
                      , dataType:"numeric"
                      , formatString:"#,##0"
                }

                , {dataField:"poNo", headerText:"PO No", width:160, editable:false}
                , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
                , {dataField:"delvryDt", headerText:"Delivery Date", width:160, editable:false
                    , dataType:"date"
                    , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                    , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                }
                , {dataField:"delvryGiDt", headerText:"Delivery GI Date", width:160, editable:false
                    , dataType:"date"
                    , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                    , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                }
                , {dataField:"delvryStatus", visible:false}
                , {dataField:"delvryStatusCode", visible:false}
                , { dataField:"printYn", headerText:"Print", width: 160
                  , renderer : {
                      type : "CheckBoxEditRenderer",   // 체크박스 렌더러
                      showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                      editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                      checkValue : true, // true, false 인 경우가 기본
                      unCheckValue : false,

                      // 체크박스 Visible 함수
                      visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                          if(item.printYn == "N" || Number(item.hmcDelvryNoDtlNo) != 1){
                              return false; //  인 경우 체크박스 표시 안함.
                          }
                          return true;
                      },

                      //사용자가 체크 상태를 변경하고자 할 때 변경을 허락할지 여부를 지정할 수 있는 함수 입니다. : (return false시, 변경안됨.)
                      checkableFunction :  function(rowIndex, columnIndex, value, isChecked, item, dataField ) {

                          // 체크했을 때.
                          if(!isChecked){
                              var items = AUIGrid.getGridData(deliveryGridID);

                              var printDs = [];
                              $.each(items, function(i, row){
                                 if(row.delvryStatusCode != "10" && Number(row.hmcDelvryNoDtlNo) == 1
                                    && rowIndex != i){
                                        printDs.push({"rowIndex":i, "hmcDelvryNo":row.hmcDelvryNo, "hmcDelvryNoDtlNo":row.hmcDelvryNoDtlNo});
                                 }
                              });

                              for(var i in printDs){
                                  AUIGrid.setCellValue(deliveryGridID, Number(printDs[i].rowIndex), "printYn", false);
                              }
                          }

                          return true;
                      }

                  }
              }

    ];
    // Delivery  그리드 속성 설정
    var deliveryGrid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      fixedColumnCount : 0,        // 틀고정(index)
      editable : false,             // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "multipleCells", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : true,     // 그리드 넘버링
      enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      useGroupingPanel : false,    // 그룹핑 패널 사용
      displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : false,      // 상태 칼럼 사용
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      rowIdField : "rnum",
      enableSorting : true,
      showRowCheckColumn : true,      // row 체크박스 표시 설정
      independentAllCheckBox : false,  // 전체 선택 체크박스가 독립적인 역할을 할지 여부
      showRowAllCheckBox : false,      // 전체 체크박스 표시 설정
      enableRestore: true,
      softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
      softRemoveRowMode : false,      // 그리드 삭제시, 바로 삭제 여부 (기본값:true : 삭제여부 표시.)

      // 엑스트라 체크박스 disabled 함수
      // 이 함수는 렌더링 시 빈번히 호출됩니다. 무리한 DOM 작업 하지 마십시오. (성능에 영향을 미침)
      rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
          if(item.delvryStatusCode != "10") { // 10 이 아닌 경우 체크박스 disabeld 처리함
              return false; // false 반환하면 disabled 처리됨
          }
          return true;
      }
    };

    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);
        detailGridID = GridCommon.createAUIGrid("detailGrid", subColumnLayout,"", subGrid_options);
        deliveryGridID = GridCommon.createAUIGrid("deliveryGrid", deliveryColumnLayout,"", deliveryGrid_options);

        // 푸터 레이아웃 세팅
        AUIGrid.setFooter(detailGridID, subFooterLayout);

        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);
        AUIGrid.setGridData(deliveryGridID, []);

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
            $("select[name=sMemAccId]").prop('disabled',true);
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

            /*
            if(js.date.dateDiff(dat1, dat2) > 61){
                Common.alert("The duration is only two months.");
                return ;
            }
            */

            // 메인 그리드 조회
            getListAjax(1);

      });

        // save
        $("#btnSave").click(function(){

            var items = AUIGrid.getGridData(detailGridID);
            if(items.length == 0){
                Common.alert("Please, Check Input item information.");
                return false;
            }

            // save validation check.
            var result = true, paramList = [];
            for (var i = 0; i < items.length; i++){
                var poNo = items[i].poNo;
                var poDtlNo = items[i].poDtlNo;

                var poQty = js.String.naNcheck(items[i].confirmQty);
                var extQty = js.String.naNcheck(items[i].extQty);
                var qcFailQty = js.String.naNcheck(items[i].qcFailQty);
                var availableQty = js.String.naNcheck(items[i].availableQty);
                var doQty = js.String.naNcheck(items[i].doQty);

                if(poQty < (extQty - qcFailQty)){
                    // PO Qty는 Delivery Qty보다 많아야 합니다.
                    Common.alert("PO Qty must be greater than Delivery Qty.<br /> PO Detail No : "+poDtlNo);
                    return false;
                }

                if( availableQty < doQty ){
                    // Available Qty는 Total 수량보다 많을수 없습니다.
                    Common.alert("Available Qty cannot be greater than DO Qty.<br /> PO Detail No : "+poDtlNo);
                    return false;
                }

                if(doQty <= 0){continue;}
                paramList.push(items[i]);
            }

            if(paramList.length == 0){
                Common.alert("No delivery QTY.");
                return false;
            }

            Common
                .confirm(
                    "<spring:message code='sys.common.alert.save'/>",
                    function(){

                    		Common.ajax("POST", "/homecare/po/hcCreateDelivery/selectProductionCompar.do"
                                    , {"poNo":paramList[0].poNo}
                                    , function(result){
                                    	var pList = result.dataList;
                                    	var dlvTot = 0;
                                    	var dlvMsg = [];

                                    	for (var i = 0; i < paramList.length; i++){
                                    		for (var k = 0; k < pList.length; k++){

                                    			if(  paramList[i].poNo == pList[k].poNo
                                    			  && paramList[i].poDtlNo == pList[k].poDtlNo
                                    			){
                                    				dlvTot = Number(paramList[i].doQty) + Number(pList[k].delvryQty);
                                    				if(dlvTot > pList[k].actualQty){
                                    					dlvMsg.push(paramList[i].poDtlNo);
                                    				}
                                    			}
                                    		}

                                    	}

                                    	if(dlvMsg.length > 0){
                                    		var dMsg = "DO QTY is smaller than Production Qty. <br />Please Check The PRODUECTION QTY IN PRODUCTION PLANS.";
                                    		    dMsg += "<br /> [PO Detail No : "+dlvMsg+"]";
                                    		Common.confirm(dMsg,
                                    			    function(){
                                    			         fn_deliverySave(paramList, items);
                                    			    });
                                    	}else{
                                    		fn_deliverySave(paramList, items);
                                    	}
                                    }
                             );

                    }
            );
        });

        // del
        $("#btnSubDel").click(function(){
            var items = AUIGrid.getCheckedRowItems(deliveryGridID);

            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            var isValid = true;
            var chList = [];
            $.each(items, function(idx, row){
                if(Number(row.item.delvryStatusCode) != 10){
                    isValid = false;
                }else{
                    chList.push(row.item);
                }
            });
            if(!isValid){
                Common.alert("Please, check the status.");
                return false;
            }

            var message = "Do you want to Delete?";
            var params = {"deleteData":chList};

            Common
                .confirm(
                    message,
                    function(){
                        Common.ajax("POST", "/homecare/po/hcCreateDelivery/deleteHcCreateDelivery.do"
                                , params
                                , function(result){
                                    AUIGrid.setGridData(deliveryGridID, result.dataList);

                                    Common.ajax("GET", "/homecare/po/hcCreateDelivery/selectPoDetailList.do"
                                            , {"sPoNo":chList[0].poNo}
                                            , function(result){
                                                   //console.log("data : " + result);
                                                   AUIGrid.setGridData(detailGridID, result.dataList);
                                    });

                                    Common.alert("<spring:message code='sys.msg.savedCnt'/>");
                                 }
                                , function(jqXHR, textStatus, errorThrown){
                                    try{
                                        console.log("Fail Status : " + jqXHR.status);
                                        console.log("code : "        + jqXHR.responseJSON.code);
                                        console.log("message : "     + jqXHR.responseJSON.message);
                                        console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                    }catch (e){
                                        console.log(e);
                                    }
                                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                        });
                    }
            );
        });

        // delivery
        $("#btnSubDelivery").click(function(){
            var items = AUIGrid.getCheckedRowItems(deliveryGridID);
            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            var isValid = true;
            var chList = [];
            $.each(items, function(idx, row){
                if(Number(row.item.delvryStatusCode) != 10){
                    isValid = false;
                }else{
                    chList.push(row.item);
                }
            });
            if(!isValid){
                Common.alert("Please, check the status.");
                return false;
            }

            var message = "Do you want to Delivery? <br /> You cannot cancel after Delivery.";
            var params = {"deliveryData":chList};

            Common
                .confirm(
                    message,
                    function(){
                        Common.ajax("POST", "/homecare/po/hcCreateDelivery/deliveryHcCreateDelivery.do"
                                , params
                                , function(result){
                                    Common.alert("<spring:message code='sys.msg.savedCnt'/>");
                                    AUIGrid.setGridData(deliveryGridID, result.dataList);
                                 }
                                , function(jqXHR, textStatus, errorThrown){
                                    try{
                                        console.log("Fail Status : " + jqXHR.status);
                                        console.log("code : "        + jqXHR.responseJSON.code);
                                        console.log("message : "     + jqXHR.responseJSON.message);
                                        console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                    }catch (e){
                                        console.log(e);
                                    }
                                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                        });
                    }
            );

        });

        $("#btnSubPrint").click(function(){
            var items = AUIGrid.getGridData(deliveryGridID);

            var checkedItems = [];
            $.each(items, function(i, row){
                if(row.printYn == true){
                    checkedItems.push(row);
                }
            });

            if(checkedItems.length == 0) {
                Common.alert('No data selected.');
                return false;
            }else if(checkedItems.length == 1 ) {
                $("#V_DELVRYNO").val(checkedItems[0].hmcDelvryNo);
                js.print.report("printForm");
            }else{
                Common.alert('only one [Delivery No] is possible.');
                return false;
            }

        });

        $("#btnCancelDelivery").click(function(){
        	var rows = AUIGrid.getSelectedItems(deliveryGridID);
        	if(rows.length == 0){
        		Common.alert("No data selected.");
                return false;
        	}

            if(rows.length != 1){
                Common.alert("Please, select one row from Delivery List.");
                return false;
            }

            var item = rows[0].item;

            if(item.delvryStatusCode == "10"){
            	Common.alert("Only delivery can be processed.");
            	return false;
            }

            if(item.delvryStatusCode != "20"){
            	Common.alert("GR processed can not be undone.");
                return false;
            }

            Common
	            .confirm(
	                "Do you want to Cancel Delivery?",
	                function(){
	                    Common.ajax("POST", "/homecare/po/hcCreateDelivery/cancelDeliveryHc.do"
	                            , {"hmcDelvryNo":item.hmcDelvryNo, "sPoNo":item.poNo}
	                            , function(result){
	                                Common.alert("<spring:message code='sys.msg.savedCnt'/>");
	                                AUIGrid.setGridData(deliveryGridID, result.dataList);
	                             }
	                            , function(jqXHR, textStatus, errorThrown){
	                                try{
	                                	Common.alert("Fail : " + jqXHR.responseJSON.message);
	                                }catch (e){
	                                    console.log(e);
	                                }
	                    });
	                }
	        );

        });

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });

        // 바코드 폰트 다운로드
        $("#btnPrintFont").click(function(){
        	window.location.href = "${pageContext.request.contextPath}/resources/font/Code39AzaleaWide2.zip";
        });

    });


    // 이벤트 정의
    $(function(){

        /*
        AUIGrid.bind(myGridID, "selectionChange", function( event ) {
            var selectedItems = event.selectedItems;
        });
        */

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

        // row 콤보박스 클릭.
        AUIGrid.bind(deliveryGridID, "rowCheckClick", function( event ) {
            console.log("rowIndex : " + event.rowIndex + ", checked : " + event.checked);
            if(event.checked){
                // 같은 번호만 체크.  (같지 않은 번호는 체크 해제)
                //AUIGrid.setCheckedRowsByValue(deliveryGridID, "hmcDelvryNo", event.item.hmcDelvryNo);

                // 같은 번호 체크. (누적되어 같은 번호 체크.)
                AUIGrid.addCheckedRowsByValue(deliveryGridID, "hmcDelvryNo", event.item.hmcDelvryNo);
            }else{
                // 같은 번호 체크해제.
                AUIGrid.addUncheckedRowsByValue(deliveryGridID, "hmcDelvryNo", event.item.hmcDelvryNo);
            }
        });

    });


//--function--//

// main grid cellClick event.
function cellClickEvent( event ){
    //console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");

    // 그리드 선택 block을 잡아준다.
    //AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
      var poNo = AUIGrid.getCellValue(myGridID, event.rowIndex, 3);
      if(poNo != oldPoNo){
        AUIGrid.setGridData(detailGridID, []);
        AUIGrid.setGridData(deliveryGridID, []);

        if(js.String.isEmpty(poNo)){
          oldPoNo = poNo;
          return false;
        }


        var subParam = {"sPoNo":poNo};
        Common.ajax("GET", "/homecare/po/hcCreateDelivery/selectPoDetailList.do"
                , subParam
                , function(result){
                       //console.log("data : " + result);
                       AUIGrid.setGridData(detailGridID, result.dataList);
        });

        var subParam = {"sPoNo":poNo};
        Common.ajax("GET", "/homecare/po/hcCreateDelivery/selectDeliveryList.do"
                , subParam
                , function(result){
                       //console.log("data : " + result);
                       AUIGrid.setGridData(deliveryGridID, result.dataList);
        });

     }
     oldPoNo = poNo;
};


// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/po/hcCreateDelivery/selectPoList.do";

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
        AUIGrid.setGridData(deliveryGridID, []);

        if(data.total > 0){
            // 행을 선택해줌.
            AUIGrid.setSelectionByIndex(myGridID, 0);
            cellClickEvent({"rowIndex":0, "columnIndex":0});
        }
    });

}

// save 처리
function fn_deliverySave(paramList, items){
    Common.ajax("POST", "/homecare/po/hcCreateDelivery/multiHcCreateDelivery.do"
            , {"saveData":paramList}
            , function(result){
                AUIGrid.setGridData(deliveryGridID, result.dataList);

                Common.ajax("GET", "/homecare/po/hcCreateDelivery/selectPoDetailList.do"
                        , {"sPoNo":items[0].poNo}
                        , function(result){
                               //console.log("data : " + result);
                               AUIGrid.setGridData(detailGridID, result.dataList);
                });

                Common.alert("<spring:message code='sys.msg.savedCnt'/>");
                //console.log("성공." + JSON.stringify(result));
             }
            , function(jqXHR, textStatus, errorThrown){
                try{
                    console.log("Fail Status : " + jqXHR.status);
                    console.log("code : "        + jqXHR.responseJSON.code);
                    console.log("message : "     + jqXHR.responseJSON.message);
                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                }catch (e){
                    console.log(e);
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}

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
    <li>PO</li>
    <li>POManager</li>
  </ul>

  <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
    <h2>Create Delivery & Statement</h2>

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
                    <td colspan="4"></td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

  <section class="search_result"><!-- search_result start -->
    <aside class="title_line"><!-- title_line start -->
        <h3>PO list</h3>
        <ul class="right_btns">
        </ul>
    </aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
        <!-- 그리드 영역1 -->
        <div id="mainGrid" style="height:250px;"></div>

        <!-- 그리드 페이징 네비게이터 -->
        <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
    </article><!-- grid_wrap end -->


    <aside class="title_line"><!-- title_line start -->
        <h3>PO Detail & delivery Management</h3>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_grid"><a id="btnSave">SAVE</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->
    <article class="grid_wrap" ><!-- grid_wrap start -->
        <!--  그리드 영역2  -->
        <div id="detailGrid" style="height:250px;"></div>
    </article><!-- grid_wrap end -->

    <aside class="title_line"><!-- title_line start -->
        <h3>Delivery List</h3>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            <li><p class="btn_grid"><a id="btnCancelDelivery">Cancel Delivery</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid"><a id="btnSubDel">Delete</a></p></li>
            <li><p class="btn_grid"><a id="btnSubDelivery">Delivery</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="btnSubPrint">Print</a></p></li>
            <li><p class="btn_grid"><a id="btnPrintFont">Print Font</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->
    <article class="grid_wrap" ><!-- grid_wrap start -->
        <!--  그리드 영역2  -->
        <div id="deliveryGrid" style="height:200px;"></div>
    </article><!-- grid_wrap end -->
  </section><!-- search_result end -->

  <form id="printForm" name="printForm">
    <input type="hidden" id="viewType" name="viewType" value="WINDOW" />
    <input type="hidden" id="V_DELVRYNO" name="V_DELVRYNO" value="" />
    <input type="hidden" id="reportFileName" name="reportFileName" value="/homecare/hcDelivery_Note_for_Gl.rpt" /><br />
  </form>

</section><!-- content end -->
