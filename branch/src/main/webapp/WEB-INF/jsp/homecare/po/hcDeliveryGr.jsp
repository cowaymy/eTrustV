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

var mSort = {};

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

var poTypeDs = [];
var poTypeObj = {};
<c:forEach var="obj" items="${poTypeList}">
  poTypeDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  poTypeObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var poStatDs = [];
var poStatObj = {};
<c:forEach var="obj" items="${poStatList}">
  poStatDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  poStatObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var uomDs = [];
<c:forEach var="obj" items="${uomList}">
  uomDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>

var curDs = [];
var curObj = {};
<c:forEach var="obj" items="${curList}">
  curDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  curObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var taxDs = [];
var taxObj = {};
<c:forEach var="obj" items="${taxList}">
  taxDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  taxObj["${obj.codeId}"] = {codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"};
</c:forEach>

    //AUIGrid 생성 후 반환 ID
    var myGridID;

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField:"hmcGrNo", headerText :"GR No", width:180, editable:false}
            , {dataField:"hmcGrNoDtlNo",headerText :"GR Detail No", width:150}
            , {dataField:"stockId", visible:false}
            , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
            , {dataField:"stockName", headerText:"Material Name", width:340, style:"aui-grid-user-custom-left", editable:false}
            , {dataField:"grYn",headerText :"GR Complete", width:100, editable:false}
            , {dataField:"rciptQty", headerText:"QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"qcFailQty", headerText:"QC Fail QTY", width:120
                , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
            }
            , {dataField:"hmcDelvryNo",headerText :"Delivery No", width:180, editable:false}
            , {dataField:"hmcDelvryNoDtlNo",headerText :"Delivery Detail No", width:150, editable:false}
    ];

    // main 그리드 속성 설정
    var grid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      //fixedColumnCount : 0,        // 틀고정(index)
      editable : false,            // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "singleCell", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      //showSelectionBorder:true,    // (녹색 테두리 선)(기본값 : true)
      //useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : true,     // 그리드 넘버링
      enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      //useGroupingPanel : false,    // 그룹핑 패널 사용
      //displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : false,      // 상태 칼럼 사용
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      //rowIdField : "poNo",
      enableSorting : false,

      showRowCheckColumn : true,      // row 체크박스 표시 설정
      independentAllCheckBox : true,  // 전체 선택 체크박스가 독립적인 역할을 할지 여부
      showRowAllCheckBox : true,      // 전체 체크박스 표시 설정

      enableRestore: true,
      //softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제

      // 엑스트라 체크박스 disabled 함수
      // 이 함수는 렌더링 시 빈번히 호출됩니다. 무리한 DOM 작업 하지 마십시오. (성능에 영향을 미침)
      // rowCheckDisabledFunction 이 아래와 같이 간단한 로직이라면, 실제로 rowCheckableFunction 정의가 필요 없습니다.
      // rowCheckDisabledFunction 으로 비활성화된 체크박스는 체크 반응이 일어나지 않습니다.(rowCheckableFunction 불필요)
      rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
          if(item.grYn != "N") { // 10 이 아닌 경우 체크박스 disabeld 처리함
              return false; // false 반환하면 disabled 처리됨
          }
          return true;
      }

    };


    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);

        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);

        // combo 내역 초기화
        doDefCombo(cdcDs, '', 'sCdc', 'S', '');
        doDefCombo(vendorDs, '', 'sMemAccId', 'S', '');

        <c:if test="${PAGE_AUTH.funcUserDefine1 != 'Y'}">
	        if(js.String.isEmpty("${zMemAccId}")){
	            $("#sMemAcc").val("N");
	        }
	        $("#sMemAccId").val("${zMemAccId}");
	        $("select[name=sMemAccId]").prop('disabled',true);
        </c:if>

        if( js.String.isEmpty($("#sDlvGiDtFrom").val()) ){
            $("#sDlvGiDtFrom").val("${threeMonthBf}");
        }
        if( js.String.isEmpty($("#sDlvGiDtTo").val()) ){
            $("#sDlvGiDtTo").val("${toDay}");
        }

        // 조회버튼
	    $("#btnSearch").click(function(){
	        if(js.String.isEmpty($("#sCdc").val()) || js.String.isEmpty($("#sMemAccId").val())){
			    Common.alert("Please, check the mandatory value.");
			    return ;
			}

			// 날짜형식 체크
			var sValidDtFrom = $("#sDlvGiDtFrom").val();
			var sValidDtTo = $("#sDlvGiDtTo").val();

			var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
			if( !date_pattern.test(sValidDtFrom)) {
			    Common.alert("Please check the date format.");
			    return ;
			}
			if( !date_pattern.test(sValidDtTo)) {
                Common.alert("Please check the date format.");
                return ;
            }

			// 메인 그리드 조회
			getListAjax(1);

	    });

        // Create GR
        $("#btnCreateGr").click(function(){
            if(Common.checkPlatformType() == "mobile") {
                popupObj = Common.popupWin("frmNew", "/homecare/po/hcDeliveryGr/hcDeliveryGrPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
            } else{
                Common.popupDiv("/homecare/po/hcDeliveryGr/hcDeliveryGrPop.do", null, null, true, '_divDeliveryGrPop', function(){$(".popup_wrap").css("width", '550px');});
            }

        });

        //
        $("#btnGR").click(function(){
        	var chkList = AUIGrid.getCheckedRowItems(myGridID);
        	if (chkList.length == 0){
                Common.alert("Please select at least 1 record.");
                return false;
            }

        	var rows = [];
        	$.each(chkList, function(idx, row){
        		rows.push(row.item);
            });

            Common
                .confirm(
                	"Do you want to GR?",
                    function(){
                        Common.ajax("POST", "/homecare/po/hcDeliveryGr/multiGridGr.do"
                                , {"grData":rows}
                                , function(result){
                                    Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                                    getListAjax(1);
                                    //console.log("성공." + JSON.stringify(result));
                                    //console.log("data : " + result.data);
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

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });

    });


    // 이벤트 정의
    $(function(){

        /*
		AUIGrid.bind(myGridID, "selectionChange", function( event ) {
            var selectedItems = event.selectedItems;
        });
        */

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

        // 전체 체크박스 클릭 이벤트 바인딩 - 엑스트라 체크
        AUIGrid.bind(myGridID, "rowAllChkClick", function( event ) {
            if(event.checked) {
                // GR_YN 의 값들 얻기
                var uniqueValues = AUIGrid.getColumnDistinctValues(event.pid, "grYn");

                // Y 코드 제거하기
                if(uniqueValues.indexOf("Y") != -1){
                    uniqueValues.splice(uniqueValues.indexOf("Y"),1);
                }

                AUIGrid.setCheckedRowsByValue(event.pid, "grYn", uniqueValues);
            } else {
                AUIGrid.setCheckedRowsByValue(event.pid, "grYn", []);
            }
        });

        // row 콤보박스 클릭.
        AUIGrid.bind(myGridID, "rowCheckClick", function( event ) {
            console.log("rowIndex : " + event.rowIndex + ", checked : " + event.checked);
            if(event.checked){
                // 같은 번호만 체크.  (같지 않은 번호는 체크 해제)
                //AUIGrid.setCheckedRowsByValue(myGridID, "hmcGrNo", event.item.hmcGrNo);

                // 같은 번호 체크. (누적되어 같은 번호 체크.)
                AUIGrid.addCheckedRowsByValue(myGridID, "hmcGrNo", event.item.hmcGrNo);
            }else{
                // 같은 번호 체크해제.
                AUIGrid.addUncheckedRowsByValue(myGridID, "hmcGrNo", event.item.hmcGrNo);
            }
        });

    });


//--function--//

// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/po/hcDeliveryGr/selectDeliveryGrMain.do";
    //var param = $("#searchForm").serialize();
    //param += "&sMemAccId="+$("#sMemAccId").val();
    var param = $("#searchForm").serializeObject();
    param.sMemAccId = $("#sMemAccId").val();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":25, "goPage":goPage}, {"sort":sortList});
    //console.log("param : ", param);

    // 초기화
    AUIGrid.setGridData(myGridID, []);

    Common.ajax("POST" , url , param , function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, data.dataList);
    });
}

function fn_PopClose() {
    if(popupObj!=null) popupObj.close();
}

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
        <li>Homecare</li>
        <li>PO Mgt.</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
        <h2>HomeCare GR</h2>

        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_blue"><a id="btnCreateGr">Create GR</a></p></li>
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
                    <th scope="row"><span style="color:red">*</span>Delivery GI Date</th>
		            <td>
		                <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="sDlvGiDtFrom" name="sDlvGiDtFrom" type="text" title="PO start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="sDlvGiDtTo" name="sDlvGiDtTo" type="text" title="PO End Date" placeholder="DD/MM/YYYY" class="j_date">
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
                    <th scope="row">Delivery No</th>
                    <td >
                        <input type="text" id="sHmcDelvryNo" name="sHmcDelvryNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">PO No</th>
                    <td >
                        <input type="text" id="sPoNo" name="sPoNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">GR Complete</th>
                    <td >
                        <input type="text" id="sGrYn" name="sGrYn" placeholder="" class="w100p" >
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->
    <form id="frmNew" name="frmNew" action="#" method="post"></form>

    <!-- data body start -->
  <section class="search_result"><!-- search_result start -->
	<aside class="title_line"><!-- title_line start -->
        <h3>List</h3>
        <%-- <ul class="right_btns">
           <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
               <li><p class="btn_grid"><a id="btnGR">GR Complete</a></p></li>
           </c:if>
        </ul> --%>
	</aside><!-- title_line end -->
	<!-- grid_wrap start -->
	<article class="grid_wrap">
	   <!-- 그리드 영역1 -->
	   <div id="mainGrid" class="autoGridHeight"></div>

	   <!-- 그리드 페이징 네비게이터 -->
       <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel autoFixArea"></div>
	</article>
	<!-- grid_wrap end -->

  </section><!-- data body end -->

</section><!-- content end -->
