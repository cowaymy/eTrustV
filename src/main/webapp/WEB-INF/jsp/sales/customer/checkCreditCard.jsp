<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    var myGridID;

    $(document).ready(function(){

        createAUIGrid();
    });

    function createAUIGrid() {
        var columnLayout = [ {
                dataField : "custId",
                headerText : "Cust ID",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "salesOrdNo",
                headerText : "Order No",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custCrcOwner",
                headerText : "Name on Card",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custCrcToken",
                headerText : "Token ID",
                width : 350,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stus",
                headerText : "Order Status",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "userName",
                headerText : "User ID",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "branchName",
                headerText : "Branch Name",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custCrcUpdDt",
                headerText : "Last Update Date",
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "tnaFlag1",
                headerText : "TNA",
                width : 50,
                editable : true,
                renderer :
                {
                    type : "CheckBoxEditRenderer",
                    showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                    editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                    checkValue : "Y", // true, false 인 경우가 기본
                    unCheckValue : "N",
                    // 체크박스 Visible 함수
                    visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
                     {
                       return true;
                     }
                }  //renderer
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
    function fn_tokenPop() {
        console.log("tokenizationBtn :: click :: fn_tokenPop");

        var refId;

        if($("#nric").val() == "") {
            Common.alert("Please key in NRIC");
            return false;
        }

        var tokenPop, tokenTick;
        var nric = "0crcChecking";
        var custId = "0crcChecking";
        var crcId = "000000000000";
        //refId = (nric.length < 12 ? pad("0" + nric, 12) : nric) + (custId.length < 12 ? pad("0" + custId, 12) : nric) + crcId;
        refId = nric + custId + crcId;

        Common.ajax("GET", "/sales/customer/getTknId.do", {refId : refId}, function(r1) {
            if(r1.tknId != 0) {
                $("#refNo").val(r1.tknRef);

                // Calls MC Payment pop up
                var option = {
                        winName: "popup",
                        isDuplicate: true, // 계속 팝업을 띄울지 여부.
                        fullscreen: "no", // 전체 창. (yes/no)(default : no)
                        location: "no", // 주소창이 활성화. (yes/no)(default : yes)
                        menubar: "no", // 메뉴바 visible. (yes/no)(default : yes)
                        titlebar: "yes", // 타이틀바. (yes/no)(default : yes)
                        toolbar: "no", // 툴바. (yes/no)(default : yes)
                        resizable: "yes", // 창 사이즈 변경. (yes/no)(default : yes)
                        scrollbars: "yes", // 스크롤바. (yes/no)(default : yes)
                        width: "768px", // 창 가로 크기
                        height: "250px" // 창 세로 크기
                    };

                if (option.isDuplicate) {
                    option.winName = option.winName + new Date();
                }

                var URL = '${mcPaymentUrl}' + r1.tknRef;

                tokenPop = window.open(URL, option.winName,
                        "fullscreen=" + option.fullscreen +
                        ",location=" + option.location +
                        ",menubar=" + option.menubar +
                        ",titlebar=" + option.titlebar +
                        ",toolbar=" + option.toolbar +
                        ",resizable=" + option.resizable +
                        ",scrollbars=" + option.scrollbars +
                        ",width=" + option.width +
                        ",height=" + option.height);

                // Set ticker to check if MC Payment pop up is still opened
                tokenTick = setInterval(
                    function() {
                        if(tokenPop.closed) {
                            console.log("tokenPop is closed!");
                            clearInterval(tokenTick);

                            // Retrieve token ID to be displayed in credit card number field
                            Common.ajax("GET", "/sales/customer/getTokenNumber.do", {refId : r1.tknRef}, function(r2) {
                                console.log(r2);
                                if(r2 != null) {
                                    if(r2.code == "99") { //FAILED
                                    	console.log("why: "+ $("#tnaFlag1").val());
                                    	$("#tnaFlag1").val('Y');
                                    	console.log("why1 : "+ $("#tnaFlag1").val());
                                        $("#CardNo").val(r2.data.bin + "******" + r2.data.cclast4);
                                        $("#tokenID").val(r2.data.token);
                                        Common.alert(r2.message);
                                    }
                                    else {
                                    	$("#tnaFlag1").val('');
                                        $("#CardNo").val(r2.data.bin + "******" + r2.data.cclast4);
                                        $("#tokenID").val(r2.data.token);
                                    }
                                }
                            });
                        }
                    }, 500);
            }
        });
    }

    function fn_searchCreditCard(){
    	Common.ajax("GET", "/sales/customer/searchCreditCard.do",$("#searchForm").serialize(), function(result) {
    		console.log(result);
    		console.log("why2 : "+ $("#tnaFlag1").val());
    		AUIGrid.setGridData(myGridID, result);
    		console.log("why3 : "+ $("#tnaFlag1").val());
    	})
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
<h2>Check Credit Card Owner</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchCreditCard()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>

    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="tnaFlag1" name="tnaFlag1">
    <input type="hidden" id="tokenID" name="tokenID">
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
                <th scope="row">Card No</th>
                <td rolspan="2">
                <input type="text" title="" id="CardNo" name="cardNo" placeholder="Card No" style="width:90%"  readonly/>
                <a href="javascript:fn_tokenPop();" class="search_btn" id="tokenizationBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>

            </tr>
        </tbody>
    </table><!-- table end -->



</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->