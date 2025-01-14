<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var custScoreCardGridID;

	$(document).ready(function(){
	    createCustScoreCardAUIGrid();
	});

	function createCustScoreCardAUIGrid() {

	    //AUIGrid 칼럼 설정
	    var columnLayout = [
	        {
	        	headerText : "<spring:message code='sales.cust.OrderNo'/>",
	            dataField : "ordNo",
	            editable : false,
	        }, {
	            headerText : "<spring:message code='sales.AppType'/>",
	            dataField : "appTypeCode",
	            editable : false,
	        },  {
	            headerText : "<spring:message code='sales.prod'/>",
	            dataField : "productName",
	            editable : false,
	        }, {
	            headerText : "<spring:message code='sales.cust.RentalStatus'/>",
	            dataField : "ordStusCode",
	            editable : false,
	        }, {
	            headerText : "<spring:message code='sales.billNoMnth'/>",
	            dataField : "billNoMonth",
	            editable : false,
	        }, {
	            headerText : "<spring:message code='sales.cust.agingMonth'/>",
	            dataField : "agingMonth",
	            editable : false,
	        }, {
	            headerText : "<spring:message code='sales.cust.payMode'/>",
	            dataField : "cardType",
	            editable : false,
	        }, {
	            headerText : "<spring:message code='sales.cust.outAmt'/>",
	            dataField : "outAmt",
	            editable : false,
	            width : 100
	        }, {
	            headerText : "Unbill Amt",
	            dataField : "unBillAmt",
	            editable : false,
	            width : 100
	        }, {
	            dataField : "combineDt",
	            visible: false
	        } ,{
	            dataField : "insDt",
	            visible: false
	        } ,{
	            dataField : "orderCancellationDate",
	            visible: false
	        }, {
	            dataField : "ordDt",
	            visible: false
	        },{
	            headerText : "Order Date <br>Installed Date <br> Cancelled Date",
	            dataField : "datecombine",
	            width:100,
	            editable : false,
	            renderer:  {type : "TemplateRenderer",
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	            },
	            labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField){
	                var html='';
	                let str = item.combineDt;
	                let res = str.replace(/,/g,"<br />");
	                html += '<p > '+res+'</p>';
	                return html;
	            }
	        }, {
	            headerText : "<spring:message code='sales.insAddr'/>",
	            dataField : "insAddr",
	            editable : false,
	            width : 200,
	            renderer:  {type : "TemplateRenderer",
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	            },
	            labelFunction: function(rowIndex, columnIndex, value, headerText, item, dataField){
	                var html='';
	                console.log(item.insArea);
	                console.log(item.insAddr);
	                if(item.memType==4){
	                    html = item.insAddr;
	                }else{
	                    html = item.insArea;
	                }
	                return html;
	            }
	         }
	      ];

        // 그리드 속성 설정
        var gridPros2 = {

            // 페이징 사용
            usePaging : true,

            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,

            editable : true,

            fixedColumnCount : 1,

            showStateColumn : false,

            displayTreeOpen : true,

            //     selectionMode : "multipleCells",

            headerHeight : 60,
            rowHeight:50,

            // 그룹핑 패널 사용
            useGroupingPanel : false,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,

            wordWrap :  true
        };

        custScoreCardGridID = AUIGrid.create("#grid_custScoreCard_wrap", columnLayout, gridPros2);
	}

    // 리스트 조회.
    function fn_selectCustScoreCardList() {
        Common.ajax("GET", "/sales/customer/customerScoreCardList", {custId : '${orderDetail.basicInfo.custId}', custIc : '${orderDetail.basicInfo.custNric}', memType: '${memType}'}, function(result) {
        	AUIGrid.setGridData(custScoreCardGridID, result);
        });
    }
</script>

<article class="tap_area"><!-- tap_area start -->
	<article class="grid_wrap"><!-- grid_wrap start -->
	<div id="grid_custScoreCard_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
	</article><!-- grid_wrap end -->
</article><!-- tap_area end -->