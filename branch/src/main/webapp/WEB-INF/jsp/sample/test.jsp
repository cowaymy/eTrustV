<html lang="ko"><head>
    <meta charset="utf-8">
    <meta content="width=1280px,user-scalable=yes,target-densitydpi=device-dpi" name="viewport">
    <title>eTrust system</title>

    






</head><body class="" id="eTrustBody"><input type="hidden" name="_TEMP_" value="">

<script>
    var javascriptLoglevel = "debug";

    function getContextPath() {
       return "";
    }
    
    var gridMsg = new Array();

    gridMsg["sys.info.grid.noDataMessage"] = "No Data to display";
    gridMsg["sys.info.grid.groupingMessage"] = "Drag a column header and drop here to group by that";
    gridMsg["sys.info.grid.filterNoValueText"] = "( Empty Value )";
    gridMsg["sys.info.grid.filterCheckAllText"] = "( Check All )";
    gridMsg["sys.info.grid.filterClearText"] = "Clear Filter";
    gridMsg["sys.info.grid.filterSearchCheckAllText"] = "( Check All Found )";
    gridMsg["sys.info.grid.filterSearchPlaceholder"] = "Search";
    gridMsg["sys.info.grid.filterOkText"] = "Okay";
    gridMsg["sys.info.grid.filterCancelText"] = "Cancel";
    gridMsg["sys.info.grid.filterItemMoreMessage"] = "Too many items...Search words";
    gridMsg["sys.info.grid.summaryText"] = "Summary";
    gridMsg["sys.info.grid.rowNumHeaderText"] = "No.";
    gridMsg["sys.info.grid.remoterPlaceholder"] = "Input your text";
    gridMsg["sys.info.grid.calendar.formatYearString"] = "yyyy";
    gridMsg["sys.info.grid.calendar.monthTitleString"] = "mmm";
    gridMsg["sys.info.grid.calendar.formatMonthString"] = "mmm, yyyy";
    gridMsg["sys.info.grid.calendar.todayText"] = "Today";
    gridMsg["sys.info.grid.calendar.uncheckDateText"] = "Delete the date";
    gridMsg["sys.info.grid.filterNumberOperatorList.eq"] = "Equal(=)";
    gridMsg["sys.info.grid.filterNumberOperatorList.gt"] = "Greater than(\u003E)";
    gridMsg["sys.info.grid.filterNumberOperatorList.gte"] = "Greater than or Equal(\u003E=)";
    gridMsg["sys.info.grid.filterNumberOperatorList.lt"] = "Less than(\u003C)";
    gridMsg["sys.info.grid.filterNumberOperatorList.lte"] = "Less than or Equal(\u003C=)";
    gridMsg["sys.info.grid.filterNumberOperatorList.ne"] = "Not Equal(!=)";
    gridMsg["sys.info.grid.calendar.titles.sun"] = "S";
    gridMsg["sys.info.grid.calendar.titles.mon"] = "M";
    gridMsg["sys.info.grid.calendar.titles.tue"] = "T";
    gridMsg["sys.info.grid.calendar.titles.wed"] = "W";
    gridMsg["sys.info.grid.calendar.titles.thur"] = "T";
    gridMsg["sys.info.grid.calendar.titles.fri"] = "F";
    gridMsg["sys.info.grid.calendar.titles.sat"] = "S";
    gridMsg["sys.info.grid.contextTexts.showonly"] = "Show only $value";
    gridMsg["sys.info.grid.contextTexts.showall.except"] = "Show all except $value";
    gridMsg["sys.info.grid.contextTexts.hide"] = "Hide $value";
    gridMsg["sys.info.grid.contextTexts.clear.filter"] = "Clear Filtering All";
    gridMsg["sys.info.grid.contextTexts.fixed.col"] = "Fixed Columns";
    gridMsg["sys.info.grid.contextTexts.clear.fixed.col"] = "Clear Fixed Columns all";
    
    gridMsg["sys.warn.grid.pdf"] = "PDF Save supports HTML5 and supports the latest version.";
</script>
    
    

    <link rel="stylesheet" type="text/css" href="/resources/css/master.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/multiple-select.css">
    <!-- AUIGrid 테마 CSS 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
    <!-- 원하는 테마가 있다면, 다른 파일로 교체 하십시오. -->
    <link href="/resources/AUIGrid/AUIGrid_style.css" rel="stylesheet">
    

    <script type="text/javascript" src="/resources/js/jquery-2.2.4.min.js"></script>    
    <!-- <script type="text/javascript" src="/resources/js/jquery.min.js"></script>  -->
    <script type="text/javascript" src="/resources/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/resources/js/jquery.ui.core.min.js"></script>
    <script type="text/javascript" src="/resources/js/jquery.ui.datepicker.min.js"></script>
    <script type="text/javascript" src="/resources/js/jquery.mtz.monthpicker.js"></script>
    
    <script type="text/javascript" src="/resources/js/common.js"></script>        <!-- 일반 공통 js -->
    <script type="text/javascript" src="/resources/js/common_pub.js"></script>        <!-- publish js -->
    
    <script type="text/javascript" src="/resources/js/util.js"></script>
    <script type="text/javascript" src="/resources/js/jquery.serializejson.js"></script> <!-- Form to jsonObject -->
    
    <script type="text/javascript" src="/resources/js/gridCommon.js"></script>    <!-- AUIGrid 공통함수. 같이 추가해 보아요~ -->

<!-- AUIGrid -->        
    <!-- AUIGrid 라이센스 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
    <script type="text/javascript" src="/resources/AUIGrid/AUIGridLicense.js"></script>
    <!-- 실제적인 AUIGrid 라이브러리입니다. 그리드 출력을 위해 꼭 삽입하십시오.--> 
    <script type="text/javascript" src="/resources/AUIGrid/messages/AUIGrid.messages.en.js"></script>
    <script type="text/javascript" src="/resources/AUIGrid/AUIGrid.js"></script>
    <script type="text/javascript" src="/resources/js/xlsx.full.min.js"></script> <!-- 그리드에 엑셀 데이터 upload 하기 위함. -->
    
    <!-- 그리드 pdf 다운로드용. -->
    <script type="text/javascript" src="/resources/AUIGrid/AUIGrid.pdfkit.js"></script>
<!-- AUIGrid -->

    <script type="text/javascript" src="/resources/js/multiple-select.js"></script>
    <script type="text/javascript" src="/resources/js/combodraw.js"></script>

    
    
    






        


    <!-- main 업무 팝업인 경우 class="solo"로 top, left 안보이게 처리 -->
    <div id="wrap"><!-- wrap start -->

    <header id="header"><!-- header start -->
    <ul class="left_opt">
        <li>Neo(Mega Deal): <span>2394</span></li> 
        <li>Sales(Key In): <span>9304</span></li> 
        <li>Net Qty: <span>310</span></li>
        <li>Outright : <span>138</span></li>
        <li>Installment: <span>4254</span></li>
        <li>Rental: <span>4702</span></li>
        <li>Total: <span>45080</span></li>
    </ul>
    <ul class="right_opt">
        <li>Login as <span>KRHQ9001-HQ</span></li>
        <li><a href="#" class="logout">Logout</a></li>
        <li><a href="#"><img src="/resources/images/common/top_btn_home.gif" alt="Home"></a></li>
        <li><a href="#"><img src="/resources/images/common/top_btn_set.gif" alt="Setting"></a></li>
    </ul>
    </header><!-- header end -->
    
    <hr>        
        
<script type="text/javascript">
    
   /*  $(function() {
        
    }); */

</script>
    
    


        



<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="/resources/images/common/logo.gif" alt="eTrust system"></a></h1>
<p class="search">
<input type="text" title="검색어 입력">
<input type="image" src="/resources/images/common/icon_lnb_search.gif" alt="검색">
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu" id="leftMenu">







</ul>

<!-- MY MENU -->
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
    <li>
    <a href="#">My menu 1depth</a>
        <ul class="inb_menu">
            <li>
                <a href="#">My menu 1depth</a>
            </li>
        </ul>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<form id="_menuForm">
    <input type="hidden" id="CURRENT_MENU_CODE" name="CURRENT_MENU_CODE" value="">
</form>

<script type="text/javaScript">

$(function() {
    if(FormUtil.isNotEmpty($("#CURRENT_MENU_CODE").val())){
        fn_addClass($("#CURRENT_MENU_CODE").val());
    }
});

// 현재 메뉴 표시.
function fn_addClass(currentMenuCode){
    var $currentLitag = $("#li_" + currentMenuCode);
    var $currentAtag = $("#a_" + currentMenuCode);
    var menuLevel = $currentLitag.attr("menu_level");

    $currentLitag.addClass("active");
    $currentAtag.addClass("on");

    var $parentLiTag = $("#li_" + $currentLitag.attr("upper_menu_code"));

    $parentLiTag.addClass("active");
    $("#a_" + $currentLitag.attr("upper_menu_code")).addClass("on");

    if(menuLevel>= 3){
        fn_addClass($parentLiTag.attr("upper_menu_code"));
    }
}

// 선택한 메뉴화면으로 이동.
function fn_menu(menuCode, menuPath){
    $("#CURRENT_MENU_CODE").val(menuCode);

    $("#_menuForm").attr({
        action : getContextPath() + menuPath,
        method : "POST"
    }).submit();
}
</script>
        





<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
    // popup 크기
    var option = {
            width : "1200px",   // 창 가로 크기
            height : "800px"    // 창 세로 크기
    };
    
    $(document).ready(function(){
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
            $("#_custId").val(event.item.custId);
            $("#_custAddId").val(event.item.custAddId);
            $("#_custCntcId").val(event.item.custCntcId);
            /* Common.popupWin("popForm", "/sales/customer/selectCustomerView.do", option); */
            Common.popupDiv("/sales/customer/selectCustomerView.do", $("#popForm").serializeJSON(), null , true);
        });
        // 셀 클릭 이벤트 바인딩
    
    });
 
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "custId",
                headerText : "ID",
                width : 140,
                editable : false
            }, {
                dataField : "codeName1",
                headerText : "Type",
                width : 160,
                editable : false
            }, {
                dataField : "codeName",
                headerText : "Corp Type",
                width : 170,
                editable : false
            }, {
                dataField : "name",
                headerText : "Name",
                editable : false
            }, {
                dataField : "nric",
                headerText : "NRIC/Company No",
                width : 170,
                editable : false
            },{
                dataField : "custAddId",
                visible : false
            },{
                dataField : "custCntcId",
                visible : false
            },{
                dataField : "undefined",
                headerText : "Edit",
                width : 170,
                renderer : {
                      type : "ButtonRenderer",
                      labelText : "Edit",
                      onclick : function(rowIndex, columnIndex, value, item) {
                           //pupupWin
                          $("#_custId").val(item.custId); // custCntcId
                          $("#_custAddId").val(item.custAddId);
                          $("#_custCntcId").val(item.custCntcId);
                          Common.popupDiv("/sales/customer/updateCustomerBasicInfoPop.do", $("#popForm").serializeJSON(), null , true);
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
            
            showStateColumn : true, 
            
            displayTreeOpen : true,
            
            selectionMode : "multipleCells",
            
            headerHeight : 30,
            
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            
            groupingMessage : "Here groupping"
        };
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }
    
    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {        
        Common.ajax("GET", "/sales/customer/selectCustomerJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        }
        );
    }
    
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '8', '','cmbTypeId', 'M' , 'f_multiCombo');            // Customer Type Combo Box
    doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','nation', 'A', '');        // Nationality Combo Box
    doGetCombo('/common/selectCodeList.do', '95', '','cmbCorpTypeId', 'M' , 'f_multiCombo');     // Company Type Combo Box
    
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
        Common.popupWin("searchForm", "/sales/customer/customerRegistPop.do", option);
    }
</script>
<form id="popForm" method="post">
    <input type="hidden" name="custId" id="_custId" value="1031"> 
    <input type="hidden" name="custAddId" id="_custAddId" value="1031">
    <input type="hidden" name="custCntcId" id="_custCntcId" value="24270">
    <input type="hidden" name="selectParam" id="_selectParam" value="2">
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="/resources/images/common/path_home.gif" alt="Home"></li>
    <li>Sales</li>
    <li>Customer</li>
    <li>Customer</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Customer list</h2>

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_insert()"><span class="new"></span>NEW</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectPstRequestDOListAjax()"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" action="#" method="post">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px">
        <col style="width:*">
        <col style="width:130px">
        <col style="width:*">
        <col style="width:170px">
        <col style="width:*">
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Customer Type</th>
        <td>
        <select id="cmbTypeId" name="cmbTypeId" class="multy_select w100p" multiple="multiple" style="display: none;">
        <option value="965">Company</option><option value="964">Individual</option></select><div class="ms-parent multy_select w100p" style="width: 100%;"><button type="button" class="ms-choice"><span class="placeholder"></span><div></div></button><div class="ms-drop bottom"><ul style="max-height: 250px;"><li class="ms-select-all"><label><input type="checkbox" data-name="selectAllcmbTypeId"> [Select all]</label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbTypeId" value="965"><span>Company</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbTypeId" value="964"><span>Individual</span></label></li><li class="ms-no-results">No matches found</li></ul></div></div>
        </td>
        <th scope="row">Customer ID</th>
        <td>
        <input type="text" title="Customer ID" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p">
        </td>
        <th scope="row">NRIC/Company No</th>
        <td>
        <input type="text" title="NRIC/Company No" id="nric" name="nric" placeholder="NRIC / Company Number" class="w100p">
        </td>
    </tr>
    <tr>
        <th scope="row">Customer Name</th>
        <td>
          <input type="text" title="Customer Name" id="name" name="name" placeholder="Customer Name" class="w100p">
        </td>
        <th scope="row">Nationality</th>
        <td>
          <select id="nation" name="nation" class="w100p"><option value="">ALL</option><option value="45">Argentina</option><option value="7">Australia</option><option value="30">Bangladesh</option><option value="39">Brazil</option><option value="28">Brunei</option><option value="33">Cambodia</option><option value="19">Canada</option><option value="12">China</option><option value="47">Denmark</option><option value="53">EUROPE</option><option value="32">Egypt</option><option value="37">Ethopia</option><option value="6">France</option><option value="18">Germany</option><option value="56">Hong Kong</option><option value="26">Hungary</option><option value="52">ITALIAN</option><option value="13">India</option><option value="11">Indonesia</option><option value="21">Iran</option><option value="43">Iraq</option><option value="35">Ireland</option><option value="10">Japan</option><option value="57">Jordan</option><option value="2">Korea</option><option value="48">Kyrgyzstan</option><option value="31">Lebanon</option><option value="36">Libya</option><option value="1">MALAYSIA</option><option value="27">Maldives</option><option value="42">Mexico</option><option value="49">Morocco</option><option value="20">Myanmar</option><option value="46">Nepal</option><option value="34">Netherlands</option><option value="23">New Zealand</option><option value="17">Nigeria</option><option value="41">Pakistan</option><option value="4">Philippine</option><option value="25">Russia</option><option value="8">Saudi Arabia</option><option value="3">Singapore</option><option value="22">South Africa</option><option value="29">Sri Lanka</option><option value="50">Sudan</option><option value="38">Sweden</option><option value="24">Switzerland</option><option value="51">SyrianArabRepublic</option><option value="16">Taiwan</option><option value="5">Thailand</option><option value="55">Turkey</option><option value="14">United Kingdom</option><option value="15">United State</option><option value="40">Uzbekistan</option><option value="44">Vietnam</option><option value="58">Yemen</option></select>
        </td>
        <th scope="row">DOB</th>
        <td>
        <input type="text" title="DOB" id="dob" name="dob" placeholder="DD/MM/YYYY" class="j_date hasDatepicker">
        </td>
    </tr>
    <tr>
        <th scope="row">V.A Number</th>
        <td>
          <input type="text" title="V.A Number" id="custVaNo" name="custVaNo" placeholder="Virtual Account (VA) Number" class="w100p">
        </td>
        <th scope="row">Company Type</th>
        <td>
          <select id="cmbCorpTypeId" name="cmbCorpTypeId" class="multy_select w100p" multiple="multiple" style="display: none;">
        <option value="1154">Bank VIP</option><option value="1152">Berhad VIP</option><option value="1174">Centralise VIP</option><option value="1333">E Portal VIP</option><option value="1151">Government</option><option value="1153">SDN BHD</option><option value="1173">SME</option></select><div class="ms-parent multy_select w100p" style="width: 100%;"><button type="button" class="ms-choice"><span class="placeholder"></span><div></div></button><div class="ms-drop bottom"><ul style="max-height: 250px;"><li class="ms-select-all"><label><input type="checkbox" data-name="selectAllcmbCorpTypeId"> [Select all]</label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1154"><span>Bank VIP</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1152"><span>Berhad VIP</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1174"><span>Centralise VIP</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1333"><span>E Portal VIP</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1151"><span>Government</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1153"><span>SDN BHD</span></label></li><li class="" style="false"><label class=""><input type="checkbox" data-name="selectItemcmbCorpTypeId" value="1173"><span>SME</span></label></li><li class="ms-no-results">No matches found</li></ul></div></div>
        </td>
        <th scope="row"></th>
        <td></td>
    </tr>
    </tbody>
    </table><!-- table end -->
    
    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show"></a></p>
    <dl class="link_list">
        <dt>Link</dt>
        <dd>
        <ul class="btns">
            <li><p class="link_btn"><a href="#">menu1</a></p></li>
            <li><p class="link_btn"><a href="#">menu2</a></p></li>
            <li><p class="link_btn"><a href="#">menu3</a></p></li>
            <li><p class="link_btn"><a href="#">menu4</a></p></li>
            <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
            <li><p class="link_btn"><a href="#">menu6</a></p></li>
            <li><p class="link_btn"><a href="#">menu7</a></p></li>
            <li><p class="link_btn"><a href="#">menu8</a></p></li>
        </ul>
        <ul class="btns">
            <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
            <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
            <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
            <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
            <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
            <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
            <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
            <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
        </ul>
        <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide"></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->
    
    </form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width: 100%; height: 480px; margin: 0px auto; position: relative;"><div class="aui-grid" tabindex="0" style="position: relative; box-sizing: content-box; overflow: hidden; width: 1113px; height: 478px;"><div class="aui-grid-grouping-panel" style="display: block; position: absolute; width: 1113px; height: 40px; left: 0px; top: 0px;"><span class="aui-grid-grouping-message">Here groupping</span></div><div class="aui-grid-header-top-bottom-line" style="display: block; position: absolute; width: 1113px; height: 1px; left: 0px; top: 39px;"></div><input class="aui-textinputer" type="text" style="padding: 0px 4px; overflow: hidden; z-index: -1; width: 1px; height: 1px; left: 1034px; top: 79px; position: absolute;"><div style="position: absolute; overflow: hidden; width: 917px; height: 404px; left: 196px; top: 40px;"><div style="position: absolute; width: 918px; height: 404px; transform: translate(0px, 0px);"><div class="aui-grid-main-panel" style="position: absolute; width: 918px; height: 404px; left: 0px; top: 0px;"><div class="aui-grid-header-panel" style="position: absolute; width: 918px; height: 30px; left: 0px; top: 0px;"><table class="aui-grid-table" style="width: 918px;"><tbody><tr style="height: 30px;"><td class="aui-grid-default-header" style="width: 160px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 152px;"><span>Type</span></div></td><td class="aui-grid-default-header" style="width: 170px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 162px;"><span>Corp Type</span></div></td><td class="aui-grid-default-header" style="width: 247px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 239px;"><span>Name</span></div></td><td class="aui-grid-default-header" style="width: 170px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 162px;"><span>NRIC/Company No</span></div></td><td class="aui-grid-default-header" style="width: 0px; display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 0px;"><span>custAddId</span></div></td><td class="aui-grid-default-header" style="width: 0px; display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 0px;"><span>custCntcId</span></div></td><td class="aui-grid-default-header aui-grid-selection-header-column" style="width: 170px;"><div class="aui-grid-renderer-base" title="" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 162px;"><span>Edit</span></div></td></tr></tbody></table></div><div class="aui-grid-body-panel" style="overflow: hidden; position: absolute; width: 918px; height: 374px; left: 0px; top: 30px;"><table class="aui-grid-table" style="width: 918px; position: absolute; left: 0px; top: 0px;"><tbody><tr class="aui-grid-row-background" style="height: 26px;"><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="width: 160px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;">Individual</div></td><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="width: 170px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="width: 247px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;">TT</div></td><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="width: 170px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;">701009106605</div></td><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="display: none; width: 0px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;">1031</div></td><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="display: none; width: 0px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;">24270</div></td><td class="aui-grid-default-column aui-grid-selection-row-bg" style="width: 170px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: block; width: 162px;"><span class="aui-grid-button-renderer">Edit</span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 152px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 239px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 162px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; display: none; width: 162px;"><span class="aui-grid-button-renderer"></span></div></td></tr></tbody></table></div><div class="aui-grid-footer-panel" style="position: absolute; display: none; width: 918px; height: 0px; left: 0px; top: 404px;"></div></div><div class="aui-grid-header-top-bottom-line" style="width: 918px; height: 1px; left: 0px; top: 30px; position: absolute;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 160px; top: 0px; width: 1px; height: 57px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 330px; top: 0px; width: 1px; height: 57px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 577px; top: 0px; width: 1px; height: 57px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 747px; top: 0px; width: 1px; height: 57px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; display: none;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; display: none;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 917px; top: 0px; width: 1px; height: 57px;"></div><div style="position: absolute; left: 158px; top: 0px; width: 5px; height: 30px;"></div><div style="position: absolute; left: 328px; top: 0px; width: 5px; height: 30px;"></div><div style="position: absolute; left: 575px; top: 0px; width: 5px; height: 30px;"></div><div style="position: absolute; left: 745px; top: 0px; width: 5px; height: 30px;"></div><div style="position: absolute;"></div><div style="position: absolute;"></div><div style="position: absolute; left: 915px; top: 0px; width: 5px; height: 30px;"></div></div></div><div class="aui-grid-left-main-panel" style="overflow: hidden; position: absolute; left: 0px; top: 40px; width: 196px; height: 404px;"><div class="aui-grid-header-panel" style="position: absolute; width: 196px; height: 30px; left: 0px; top: 0px;"><table class="aui-grid-table" style="width: 196px;"><tbody><tr style="height: 30px;"><td class="aui-grid-default-header aui-grid-row-num-header" style="width: 40px;"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; white-space: nowrap; word-wrap: normal; width: 36px;">No.</div></td><td class="aui-grid-default-header aui-grid-row-state-header" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-header" style="width: 140px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 132px;"><span>ID</span></div></td></tr></tbody></table></div><div class="aui-grid-body-panel" style="overflow: hidden; position: absolute; width: 196px; height: 374px; left: 0px; top: 30px;"><table class="aui-grid-table" style="width: 196px; position: absolute; left: 0px; top: 0px;"><tbody><tr class="aui-grid-row-background" style="height: 26px;"><td class="aui-grid-row-num-column aui-grid-selection-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: block;">1</div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column aui-grid-selection-row-others-bg" style="width: 140px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;">1031</div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 132px;"></div></td></tr></tbody></table></div><div class="aui-grid-footer-panel" style="position: absolute; width: 196px; height: 0px; left: 0px; top: 404px;"></div><div class="aui-grid-header-top-bottom-line" style="width: 197px; height: 1px; left: 0px; top: 30px; position: absolute;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; width: 1px; height: 57px; left: 40px; top: 0px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; width: 1px; height: 57px; left: 56px; top: 0px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 196px; top: 0px; width: 1px; height: 57px;"></div><div style="position: absolute; left: 194px; top: 0px; width: 5px; height: 30px;"></div></div><div class="aui-grid-fixed-column-rule" style="pointer-events: none; position: absolute; height: 57px; left: 196px; top: 40px;"></div><div class="aui-grid-fixed-column-rule" style="pointer-events: none; position: absolute;"></div><div style="position: absolute; display: none; left: 0px; top: 443px;"></div><div class="aui-grid-fixed-row-rule" style="display: none; position: absolute;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: block; left: 943px; top: 70px; width: 170px; height: 2px;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: block; left: 943px; top: 95px; width: 170px; height: 2px;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: block; left: 943px; top: 70px; width: 2px; height: 25px;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: block; left: 1111px; top: 70px; width: 2px; height: 25px;"></div><div class="aui-hscrollbar" style="position: absolute; display: none;"><div class="aui-scroll-track" style="position: absolute;"></div><div class="aui-scroll-thumb" style="position: absolute;"></div><div class="aui-scroll-up" style="position: absolute;"></div><div class="aui-scroll-down" style="position: absolute;"></div></div><div class="aui-vscrollbar" style="position: absolute; display: none;"><div class="aui-scroll-track" style="position: absolute; left: 0px; top: 0px;"></div><div class="aui-scroll-thumb" style="position: absolute; display: none;"></div><div class="aui-scroll-up" style="position: absolute; display: block; left: 0px; top: 0px;"></div><div class="aui-scroll-down" style="position: absolute; display: block;"></div></div><div style="display: none; z-index: 40; position: absolute;"></div><div class="aui-grid-info-layer" style="z-index: 1; position: absolute; display: none;"></div><div style="z-index: 40; position: absolute;"></div><div class="aui-grid-paging-panel" style="position: absolute; width: 1113px; height: 34px; left: 0px; top: 444px;"><span class="aui-grid-paging-info-text" style="position: absolute;">1 ~ 1 of 1 rows</span><span class="aui-grid-paging-number aui-grid-paging-first" style="display: none;">&lt;&lt;</span><span class="aui-grid-paging-number aui-grid-paging-prev" style="display: none;">&lt;</span><span class="aui-grid-paging-number aui-grid-paging-number-selected" style="">1</span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number aui-grid-paging-next" style="display: none;">&gt;</span><span class="aui-grid-paging-number aui-grid-paging-last" style="display: none;">&gt;&gt;</span></div><div class="aui-grid-vertical-resizer-rule" style="width: 1px; height: 478px; left: 0px; top: 40px; position: absolute; display: none;"></div></div></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->
</section><!-- content end -->

        

    <aside class="bottom_msg_box"><!-- bottom_msg_box start -->
    <p>Information Message Area</p>
    </aside><!-- bottom_msg_box end -->
            
    </section><!-- container end -->
    <hr>
    
    <div id="_loading" class="prog" style="display: none;"><!-- prog start -->
        <p>
        <span><img src="/resources/images/common/logo_coway2.gif" alt="Coway"></span>
        <span><img src="/resources/images/common/proge.gif" alt="loding...."></span>
        </p>
    </div><!-- prog end -->
    
    </div><!-- wrap end -->





<div id="ui-datepicker-div" class="ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div><div id="_popupDiv" name="_popupDiv">













<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var addrGridID; // address list

$(document).ready(function(){
    /*  Gird */
    //AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
    createAddrGrid();
    fn_getCustomerAddressAjax(); // address list
    
    /* Move Page */
    $("#_editCustomerInfo").change(function(){
          
        var stateVal = $(this).val();
        $("#_selectParam").val(stateVal);
        
    });
    
$("#_confirm").click(function () {
        
        var status = $("#_selectParam").val();
        
        if(status == '1'){
            Common.popupDiv("/sales/customer/updateCustomerBasicInfoPop.do", $("#editForm").serializeJSON(), null , true);
            $("#_close").click();
        }
        if(status == '2'){
            Common.popupDiv("/sales/customer/updateCustomerAddressPop.do", $("#editForm").serializeJSON(), null , true);
            $("#_close").click();
        }
        if(status == '3'){
            Common.popupDiv("/sales/customer/updateCustomerContactPop.do", $("#editForm").serializeJSON(), null , true);
            $("#_close").click();
        }
        if(status == '4'){
            Common.popupDiv("/sales/customer/updateCustomerBankAccountPop.do", $("#editForm").serializeJSON(), null , true);
            $("#_close").click();
        }
        if(status == '5'){
            Common.popupDiv("/sales/customer/updateCustomerCreditCardPop.do", $("#editForm").serializeJSON(), null , true);
            $("#_close").click();
        }
        if(status == '6'){ //추후 정책 
            Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#editForm").serializeJSON(), null , true);
            $("#_close").click();
        }
        
    });
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(addrGridID, "cellDoubleClick", function(event){
        $("#custId").val(event.item.custId);
        $("#custAddId").val(event.item.custAddId);
        Common.popupDiv("/sales/customer/updateCustomerAddressInfoPop.do", $("#editForm").serializeJSON(), null , true);
    }); 
});// Document Ready End
    
    function createAddrGrid(){
    
        var addrColumnLayout = [ {
            dataField : "name",
            headerText : "Status",
            width : '10%'
        }, {
            dataField : "addr",
            headerText : "Address",
            width : '80%'
        }, {
            dataField : "custAddId",
            visible : false
        },{
            dataField : 'custId',
            visible : false
        },{
            dataField : 'stusCodeId',
            visible : false
        },{ 
            dataField : "setMain", 
            headerText : "Set As Main", 
            width:'10%', 
            renderer : { 
                type : "TemplateRenderer", 
                editable : true // 체크박스 편집 활성화 여부(기본값 : false)
            }, 
            // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음. 
            labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성 
                var html = '';
            
                html += '<label><input type="radio" name="setmain"  onclick="javascript: fn_setMain(' + item.custAddId + ','+item.custId+')"';
                
                if(item.stusCodeId == 9){
                    html+= ' checked = "checked"';
                    html+= ' disabled = "disabled"';
                }
                
                html += '/></label>'; 
                
                return html;
            } 
            
          }];
        
        //그리드 속성 설정
        var gridPros = {
                
                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 1,            
                showStateColumn     : true,             
                displayTreeOpen     : false,            
                selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
        addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", addrColumnLayout,'', gridPros);  // address list
    
    }
    
    // Get address by Ajax
    function fn_getCustomerAddressAjax() {        
        Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList",$("#editForm").serialize(), function(result) {
            AUIGrid.setGridData(addrGridID, result);
        });
    }
    
    // Popup Option     
    var option = {
            
            location : "no", // 주소창이 활성화. (yes/no)(default : yes)
            width : "1200px", // 창 가로 크기
            height : "400px" // 창 세로 크기
    };
    
    // set Main Func (Confirm)
    function fn_setMain(custAddId, custId){ //sys.common.alert.save // Do you want to save?
        $("#custId").val(custId);
        $("#custAddId").val(custAddId); 
        Common.confirm("Are you sure want to set this address as main address ?", fn_changeMainAddr, fn_reloadPage);
        /*
            1. Are you sure want to set this address as main address ?
            2. Do you want to save?     
        */
    }
    
    //call Ajax(Set Main Address)
    function fn_changeMainAddr(){
        
        Common.ajax("GET", "/sales/customer/updateCustomerAddressSetMain.do", $("#editForm").serialize(), function(result){
            //result alert and reload
            Common.alert(result.message, fn_reloadPage);
        });
    }
    
    function fn_reloadPage(){
        //Parent Window Method Call
        window.opener.parent.fn_selectPstRequestDOListAjax();
        $("#editForm").attr({"target" :"_self" , "action" : "/sales/customer/updateCustomerAddressPop.do" }).submit();
    }
    
</script>
<div id="popup_wrap" class="popup_wrap ui-draggable"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>PST Request Info</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<!-- move Page & set Main Address Form  -->
<!-- move Page Form  -->
<form id="editForm">
    <input type="hidden" name="custId" value="1031">
    <input type="hidden" name="custAddId" value="1031">
    <input type="hidden" name="custCntcId" value="24270"> 
    <input type="hidden" name="selectParam" id="_selectParam">
</form>
<section class="pop_body"><!-- pop_body start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px">
    <col style="width:*">
</colgroup>
<tbody>
<tr>
    <th scope="row">EDIT Type</th>
    <td>
     <select id="_editCustomerInfo">
        <option value="1">Edit Basic Info</option>
        <option value="2">Edit Customer Address</option>
        <option value="3">Edit Contact Info</option>
        <option value="4">Edit Bank Account</option>
        <option value="5">Edit Credit Card</option>
    </select>
    <p class="btn_sky"><a href="#" id="_confirm">Confirm</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt10"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Main Address</a></li>
    <li><a href="#">Main Contact</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px">
    <col style="width:*">
    <col style="width:150px">
    <col style="width:*">
    <col style="width:120px">
    <col style="width:*">
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>1031</span></td>
    <th scope="row">Customer Type</th>
    <td>
        <span> 
                Individual
                <!-- not Individual -->  
                
            </span>
    </td>
    <th scope="row">Create At</th>
    <td>11-10-2007  12:00:00</td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3">TT</td>
    <th scope="row">Create By</th>
    <td>
        
    </td>
</tr>
<tr>
    <th scope="row">NRIC/Company Number</th>
    <td><span>701009106605</span></td>
    <th scope="row">GST Registration No</th>
    <td></td>
    <th scope="row">Update By</th>
    <td>WTONGLIM</td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>1231@saf.com</span></td>
    <th scope="row">Nationality</th>
    <td>MALAYSIA</td>
    <th scope="row">Update At</th>
    <td>11-08-0017  12:00:00</td>
</tr>
<tr>
    <th scope="row">Gender</th>
    <td><span>F</span></td>
    <th scope="row">DOB</th>
    <td>
        
                26-08-2017
        
    </td>
    <th scope="row">Race</th>
    <td>Korean</td>
</tr>
<tr>
    <th scope="row">Passport Expire</th>
    <td><span>02-11-2017</span></td>
    <th scope="row">Visa Expire</th>
    <td>18-01-2018</td>
    <th scope="row">VA Number</th>
    <td>98 9920 0000 1031</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><span>zzzzzzzzzz</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
<!-- ######### main address info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px">
    <col style="width:*">
</colgroup>
<tbody>
<tr>
    <th scope="row">Full Address</th>
    <td>
        <span>
                FIRST&nbsp;SECOND&nbsp;THIRD&nbsp;
                &nbsp;&nbsp;&nbsp;Egypt
        </span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>ASDFASDF</td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<!-- ######### main Contact info ######### -->
<article class="tap_area"><!-- tap_area start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px">
    <col style="width:*">
    <col style="width:140px">
    <col style="width:*">
    <col style="width:120px">
    <col style="width:*">
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td><span>abc</span></td>
    <th scope="row">Initial</th>
    <td><span>DATIN</span></td>
    <th scope="row">Genders</th>
    <td>
            
                
                     Male
                
                
                
            
     </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>444444444444</span></td>
    <th scope="row">DOB</th>
    <td>
        <span>
             
        </span>
    </td>
    <th scope="row">Race</th>
    <td><span>Indian</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><span>1231@saf.com</span></td>
    <th scope="row">Department</th>
    <td><span></span></td>
    <th scope="row">Post</th>
    <td><span></span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>0172330596</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>0389432320</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>0389432320</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->
</section><!-- tap_wrap end -->
<!-- ########## Basic Info End ##########  -->
<!-- ########## Address Grid Start ########## -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">ADD New Address</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="address_grid_wrap" style="width: 100%; height: 480px; margin: 0px auto; position: relative;"><div class="aui-grid" tabindex="0" style="position: relative; box-sizing: content-box; overflow: hidden; width: 941px; height: 478px;"><div class="aui-grid-grouping-panel" style="display: none; position: absolute; width: 941px; height: 34px;"></div><div style="display: none; position: absolute;"></div><input class="aui-textinputer" type="text" style="padding: 0px 4px; overflow: hidden; z-index: -1; width: 1px; height: 1px; left: 5px; top: 5px; position: absolute;"><div style="position: absolute; overflow: hidden; width: 796px; height: 444px; left: 145px; top: 0px;"><div style="position: absolute; width: 798px; height: 444px; transform: translate(0px, 0px);"><div class="aui-grid-main-panel" style="position: absolute; width: 798px; height: 444px; left: 0px; top: 0px;"><div class="aui-grid-header-panel" style="position: absolute; width: 798px; height: 30px; left: 0px; top: 0px;"><table class="aui-grid-table" style="width: 798px;"><tbody><tr style="height: 30px;"><td class="aui-grid-default-header" style="width: 708px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 700px;"><span>Address</span></div></td><td class="aui-grid-default-header" style="width: 0px; display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 0px;"><span>custAddId</span></div></td><td class="aui-grid-default-header" style="width: 0px; display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 0px;"><span>custId</span></div></td><td class="aui-grid-default-header" style="width: 0px; display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 0px;"><span>stusCodeId</span></div></td><td class="aui-grid-default-header" style="width: 89px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 81px;"><span>Set As Main</span></div></td></tr></tbody></table></div><div class="aui-grid-body-panel" style="overflow: hidden; position: absolute; width: 798px; height: 414px; left: 0px; top: 30px;"><table class="aui-grid-table" style="width: 798px; position: absolute; left: 0px; top: 0px;"><tbody><tr class="aui-grid-row-background" style="height: 26px;"><td class="aui-grid-default-column" style="width: 708px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;">FIRST SECOND THIRD    Egypt</div></td><td class="aui-grid-default-column" style="display: none; width: 0px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;">1031</div></td><td class="aui-grid-default-column" style="display: none; width: 0px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;">1031</div></td><td class="aui-grid-default-column" style="display: none; width: 0px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;">9</div></td><td class="aui-grid-default-column" style="width: 89px;"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper" style="height: 24px;"><label><input type="radio" name="setmain" onclick="javascript: fn_setMain(1031,1031)" checked="checked" disabled="disabled"></label></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 700px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column" style="display: none;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; white-space: nowrap; width: 0px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base aui-grid-template-renderer" style="padding: 0px 4px; overflow: hidden; position: relative; white-space: nowrap; width: 81px;"><div class="aui-grid-template-renderer-wrapper"></div></div></td></tr></tbody></table></div><div class="aui-grid-footer-panel" style="position: absolute; display: none; width: 798px; height: 0px; left: 0px; top: 444px;"></div></div><div class="aui-grid-header-top-bottom-line" style="width: 798px; height: 1px; left: 0px; top: 30px; position: absolute;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 708px; top: 0px; width: 1px; height: 57px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; display: none;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; display: none;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; display: none;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 797px; top: 0px; width: 1px; height: 57px;"></div><div style="position: absolute; left: 706px; top: 0px; width: 5px; height: 30px;"></div><div style="position: absolute;"></div><div style="position: absolute;"></div><div style="position: absolute;"></div><div style="position: absolute; left: 795px; top: 0px; width: 5px; height: 30px;"></div></div></div><div class="aui-grid-left-main-panel" style="overflow: hidden; position: absolute; left: 0px; top: 0px; width: 145px; height: 444px;"><div class="aui-grid-header-panel" style="position: absolute; width: 145px; height: 30px; left: 0px; top: 0px;"><table class="aui-grid-table" style="width: 145px;"><tbody><tr style="height: 30px;"><td class="aui-grid-default-header aui-grid-row-num-header" style="width: 40px;"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; white-space: nowrap; word-wrap: normal; width: 36px;">No.</div></td><td class="aui-grid-default-header aui-grid-row-state-header" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-header" style="width: 89px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; word-wrap: normal; white-space: nowrap; width: 81px;"><span>Status</span></div></td></tr></tbody></table></div><div class="aui-grid-body-panel" style="overflow: hidden; position: absolute; width: 145px; height: 414px; left: 0px; top: 30px;"><table class="aui-grid-table" style="width: 145px; position: absolute; left: 0px; top: 0px;"><tbody><tr class="aui-grid-row-background" style="height: 26px;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: block;">1</div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column" style="width: 89px;"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;">Main</div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr><tr class="" style="height: 26px; display: none;"><td class="aui-grid-row-num-column"><div class="aui-grid-renderer-base" style="padding: 0px 2px; overflow: hidden; width: 36px; display: none;"></div></td><td class="aui-grid-row-state-column" style="width: 16px;"><div class="aui-grid-renderer-base" style="padding: 0px; overflow: hidden; width: 16px; height: 1px;"></div></td><td class="aui-grid-default-column"><div class="aui-grid-renderer-base" style="padding: 0px 4px; overflow: hidden; white-space: nowrap; width: 81px;"></div></td></tr></tbody></table></div><div class="aui-grid-footer-panel" style="position: absolute; width: 145px; height: 0px; left: 0px; top: 444px;"></div><div class="aui-grid-header-top-bottom-line" style="width: 146px; height: 1px; left: 0px; top: 30px; position: absolute;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; width: 1px; height: 57px; left: 40px; top: 0px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; width: 1px; height: 57px; left: 56px; top: 0px;"></div><div class="aui-grid-vertical-grid-lines" style="pointer-events: none; position: absolute; left: 145px; top: 0px; width: 1px; height: 57px;"></div><div style="position: absolute; left: 143px; top: 0px; width: 5px; height: 30px;"></div></div><div class="aui-grid-fixed-column-rule" style="pointer-events: none; position: absolute; height: 57px; left: 145px; top: 0px;"></div><div class="aui-grid-fixed-column-rule" style="pointer-events: none; position: absolute;"></div><div style="position: absolute; display: none; left: 0px; top: 443px;"></div><div class="aui-grid-fixed-row-rule" style="display: none; position: absolute;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: none;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: none;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: none;"></div><div class="aui-grid-selection-cell-border-lines" style="position: absolute; pointer-events: none; border: none; display: none;"></div><div class="aui-hscrollbar" style="position: absolute; display: none;"><div class="aui-scroll-track" style="position: absolute;"></div><div class="aui-scroll-thumb" style="position: absolute;"></div><div class="aui-scroll-up" style="position: absolute;"></div><div class="aui-scroll-down" style="position: absolute;"></div></div><div class="aui-vscrollbar" style="position: absolute; display: none;"><div class="aui-scroll-track" style="position: absolute; left: 0px; top: 0px;"></div><div class="aui-scroll-thumb" style="position: absolute; display: none;"></div><div class="aui-scroll-up" style="position: absolute; display: block; left: 0px; top: 0px;"></div><div class="aui-scroll-down" style="position: absolute; display: block;"></div></div><div style="display: none; z-index: 40; position: absolute;"></div><div class="aui-grid-info-layer" style="z-index: 1; position: absolute; display: none;"></div><div style="z-index: 40; position: absolute;"></div><div class="aui-grid-paging-panel" style="position: absolute; width: 941px; height: 34px; left: 0px; top: 444px;"><span class="aui-grid-paging-info-text" style="position: absolute;">1 ~ 1 of 1 rows</span><span class="aui-grid-paging-number aui-grid-paging-first" style="display: none;">&lt;&lt;</span><span class="aui-grid-paging-number aui-grid-paging-prev" style="display: none;">&lt;</span><span class="aui-grid-paging-number aui-grid-paging-number-selected" style="">1</span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number" style="display: none;"></span><span class="aui-grid-paging-number aui-grid-paging-next" style="display: none;">&gt;</span><span class="aui-grid-paging-number aui-grid-paging-last" style="display: none;">&gt;&gt;</span></div><div class="aui-grid-vertical-resizer-rule" style="width: 1px; height: 478px; left: 0px; top: 0px; position: absolute; display: none;"></div></div></div>
</article><!-- grid_wrap end -->
<!-- ########## Address Grid End ########## -->
</section><!-- pop_body end -->
</div>

</div></body></html>