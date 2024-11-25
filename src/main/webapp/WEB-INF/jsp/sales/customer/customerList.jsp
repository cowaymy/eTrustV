<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var custGridID;

    // popup 크기
    var option = {
            width : "1200px",   // 창 가로 크기
            height : "500px"    // 창 세로 크기
    };

    var basicAuth = false;


    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

   //     AUIGrid.setSelectionMode(custGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(custGridID, "cellDoubleClick", function(event){
            $("#_custId").val(event.item.custId);
            $("#_custAddId").val(event.item.custAddId);
            $("#_custCntcId").val(event.item.custCntcId);
            
            if('${PAGE_AUTH.funcUserDefine22}'  != 'Y') {
                Common.alert('<spring:message code="sal.alert.msg.accRights" />' + DEFAULT_DELIMITER + '<b><spring:message code="sal.alert.msg.noAccRights" /></b>');
            } else {
            	Common.popupDiv("/sales/customer/selectCustomerView.do", $("#popForm").serializeJSON());
            }
        });
        // 셀 클릭 이벤트 바인딩

        //TODO 미개발
        $("#_custVALetterBtn").click(function() {

            //Param Set
            var gridObj = AUIGrid.getSelectedItems(custGridID);


            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert('<spring:message code="sal.alert.msg.noCustSel" />');
                return;
            }

            var custID = gridObj[0].item.custId;
            $("#_repCustId").val(custID);
            console.log("custID : " + $("#_repCustId").val());

            fn_report();
            //Common.alert('The program is under development.');
        });

        $("#_custVALetterBtn2").click(function() {

            //Param Set
            var gridObj = AUIGrid.getSelectedItems(custGridID);


            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert('<spring:message code="sal.alert.msg.noCustSel" />');
                return;
            }

            var custID = gridObj[0].item.custId;
            $("#_repCustId2").val(custID);
            console.log("custID : " + $("#_repCustId2").val());

            var date = new Date().getDate();
            if(date.toString().length == 1){
                date = "0" + date;
            }
            $("#downFileName_V2").val("CustomerVALetter_"+custID+"_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

            fn_letter_report_V2();
        });

        //Search
        $("#_listSearchBtn").click(function() {

            //Validation
            //custId ,  nric , name
            if((null == $("#custId").val() || '' == $("#custId").val()) && (null == $("#_nric").val() || '' == $("#_nric").val())  && (null == $("#name").val() || '' == $("#name").val())){

            	//VA number
            	if($("#custVaNo").val() == null || $("#custVaNo").val() == ''){
            		Common.alert('<spring:message code="sal.alert.msg.plzKeyInAtleastOneOfTheCondition" />');
                    return;
                }
            }

            fn_selectPstRequestDOListAjax();
        });

        $("#_editDeactCustomer").click(function() {
        	var gridObj = AUIGrid.getSelectedItems(custGridID);

        	var param = gridObj[0].item;
            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert('<spring:message code="sal.alert.msg.noCustSel" />');
                return;
            }else{
                Common.popupDiv("/sales/customer/customerEditDeactivatePop.do", param, null, true, '_editDiv7');
            }
        });


        //Basic Auth (update Btn)
        if('${PAGE_AUTH.funcUserDefine2}' == 'Y'){
        	basicAuth = true;
        }
    });

    function fn_tokenTest() {
        Common.popupDiv("/sales/customer/tokenCustCrcTest.do", $("#searchForm").serializeJSON(), null, true, '_cardDiv');
    }

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "custId",
                headerText : '<spring:message code="sal.title.id" />',
                width : 140,
                editable : false
            }, {
                dataField : "codeName1",
                headerText : '<spring:message code="sal.title.type" />',
                width : 160,
                editable : false
            }, {
                dataField : "codeName",
                headerText : '<spring:message code="sal.title.text.corpType" />',
                width : 170,
                editable : false
            }, {
                dataField : "name",
                headerText : '<spring:message code="sal.text.name" />',
                editable : false
            }, {
                dataField : "nric",
                headerText : '<spring:message code="sal.title.text.nricCompNo" />',
                width : 170,
                editable : false
            }, {
                dataField : "custStatus",
                headerText : '<spring:message code="sal.text.custStus" />',
                width : 170,
                editable : false
            }, {
                dataField : "custTier",
                headerText : '<spring:message code="sal.title.text.custTier" />',
                width : 170,
                editable : false
            },{
                dataField : "custAddId",
                visible : false
            },{
                dataField : "custCntcId",
                visible : false
            },{
                dataField : "updDt",
                visible : false
            },{
                dataField : "undefined",
                headerText : "Edit",
                width : 170,
                renderer : {
                      type : "ButtonRenderer",
                      labelText : "Edit",
                      onclick : function(rowIndex, columnIndex, value, item) {
                    	  console.log("edit :: " + item.nric);
                           //pupupWin
                          $("#_custId").val(item.custId);
                          $("#_custAddId").val(item.custAddId);
                          $("#_custCntcId").val(item.custCntcId);
                          $("#_custNric").val(item.nric);                                   
                          Common.popupDiv("/sales/customer/updateCustomerBasicInfoPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv1');
                      }
               }
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

       //     selectionMode : "multipleCells",

            headerHeight : 30,

            // 그룹핑 패널 사용
            useGroupingPanel : false,

            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,

            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,

            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true
        };

        //custGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        custGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }

    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {
        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(custGridID, result);
        }
        );
    }

    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '8', '','cmbTypeId', 'M' , 'f_multiCombo');            // Customer Type Combo Box
    doGetCombo('/sales/customer/getNationList', '338' , '' ,'nation' , 'S');        // Nationality Combo Box
    doGetCombo('/common/selectCodeList.do', '95', '','cmbCorpTypeId', 'M' , 'f_multiCombo');     // Company Type Combo Box
    doGetCombo('/common/selectCodeList.do', '538', '','cmbCustTierId', 'M' , 'f_multiCombo');    // Customer Tier Combo Box

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#cmbTypeId').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
            $('#cmbCorpTypeId').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

        });
    }

    function fn_insert(){
     //   Common.popupWin("searchForm", "/sales/customer/customerRegistPop.do", option);
        Common.popupDiv("/sales/customer/customerRegistPop.do", $("#searchForm").serializeJSON(), null, true, '_insDiv');
    }

    function fn_report() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm", option);
    }

    function fn_letter_report_V2() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm3", option);
    }


    function fn_comboAuthCtrl(){
    	var status = $("#_selectParam").val();

        if(status == '1'){
            if('${PAGE_AUTH.funcUserDefine2}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerBasicInfoPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv1');
                $("#_close").click();
            }else{
                Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
            }
        }
        if(status == '2'){
            if('${PAGE_AUTH.funcUserDefine3}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2');
                $("#_close").click();
            }else{
                Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
            }
        }
        if(status == '3'){
            if('${PAGE_AUTH.funcUserDefine4}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerContactPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
                $("#_close").click();
            }else{
                Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
            }
        }
        if(status == '4'){
            if('${PAGE_AUTH.funcUserDefine5}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerBankAccountPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv4');
                $("#_close").click();
            }else{
                Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
            }
        }
        if(status == '5'){
            if('${PAGE_AUTH.funcUserDefine6}' == 'Y'){
                Common.popupDiv('/sales/customer/updateCustomerCreditCardPop.do', $('#popForm').serializeJSON(), null , true , '_editDiv5');
                $("#_close").click();
            }else{
                Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
            }
        }
        if(status == '6'){
            if('${PAGE_AUTH.funcUserDefine7}' == 'Y'){
                Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv6');
                $("#_close").click();
            }else{
                Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
            }
        }
    }
</script>

<form id="popForm" method="post">
    <input type="hidden" name="custId"  id="_custId"/>  <!-- Cust Id  -->
    <input type="hidden" name="custAddId"   id="_custAddId"/><!-- Address Id  -->
    <input type="hidden" name="custCntcId"   id="_custCntcId"> <!--Contact Id  -->
    <input type="hidden" name="custAccId"   id="_custAccId">
    <input type="hidden" name="_custNric"   id="_custNric">
    <input type="hidden" name="selectParam"  id="_selectParam" value="${selectParam}"/> <!-- Page Param  -->
</form>
<!-- edit Pop Form  -->
<form id="editForm" method="post">
    <input type="hidden" name="editCustId" id="_editCustId"/>
    <input type="hidden" name="editCustAddId" id="_editCustAddId"/>
    <input type="hidden" name="editCustCntcId" id="_editCustCntcId">
    <input type="hidden" name="editCustBankId" id="_editCustBankId">
    <input type="hidden" name="editCustCardId" id="_editCustCardId">
    <input type="hidden" name="editCustNric" id="_editCustNric">
    <input type="hidden" name="pageAuth"  id="pageAuth" value="${PAGE_AUTH.funcUserDefine21}"/> <!-- Page Param  -->
</form>
<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/CustVALetter.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_repCustId" name="@CustID" />
</form>

<form id="dataForm3">
    <input type="hidden" id="fileName" name="reportFileName" value="/sales/CustVALetter_V2.rpt" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="downFileName_V2" name="reportDownFileName" value="" /> <!-- Download Name -->

    <!-- params -->
    <input type="hidden" id="_repCustId2" name="@CustID" />
</form>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.custList" /></h2>

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_insert()"><span class="new"></span><spring:message code="sal.title.text.new" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_listSearchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:170px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row"><spring:message code="sal.text.custType" /></th>
        <td>
        <select id="cmbTypeId" name="cmbTypeId" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="sal.text.customerId" /></th>
        <td>
        <input type="text" title="Customer ID" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
        <td>
        <input type="text" title="NRIC/Company No" id="_nric" name="nric" placeholder="NRIC / Company Number" class="w100p" " />
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.custName" /></th>
        <td>
          <input type="text" title="Customer Name" id="name" name="name" placeholder="Customer Name" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.text.nationality" /></th>
        <td>
          <select  id="nation" name="nation" class="w100p"></select>
        </td>
        <th scope="row"><spring:message code="sal.text.dob" /></th>
        <td>
        <input type="text" title="DOB" id="_dob" name="dob" placeholder="DD/MM/YYYY" class="j_date" />
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.vaNum" /></th>
        <td>
          <input type="text" title="V.A Number" id="custVaNo" name="custVaNo" placeholder="Virtual Account (VA) Number" class="w100p" />
        </td>
        <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
        <td>
          <select id="cmbCorpTypeId" name="cmbCorpTypeId" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.custTier" /></th>
        <td>
          <select id="cmbCustTierId" name="cmbCustTierId" class="multy_select w100p" multiple="multiple">
        </select>
        </td>
    </tr>
    </tbody>
    </table><!-- table end -->

    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>
        <ul class="btns">
<!--             <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}"> -->
 <!--            <li><p class="link_btn"><a href="#" id="_custVALetterBtn"><spring:message code="sal.title.text.custVaLetter" /></a></p></li> -->
     <!--        </c:if> -->
             <c:if test="${PAGE_AUTH.funcUserDefine20 == 'Y'}">
            <li><p class="link_btn"><a href="#" id="_custVALetterBtn2">Customer VA Letter Version 2</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">
            <li><p class="link_btn"><a href="#" id="tokenTest" onclick="javascript:fn_tokenTest()">Tokenization Test (IT Usage only)</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
            <li><p class="link_btn"><a href="#" id="_editDeactCustomer">Edit/Deactivate Customer</a></p></li>
            </c:if>

        </ul>
        <ul class="btns">
        </ul>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->
