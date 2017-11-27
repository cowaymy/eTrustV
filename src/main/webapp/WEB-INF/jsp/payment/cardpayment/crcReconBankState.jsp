<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    //AUIGrid 그리드 객체
    var mappedGridID;
    var crcStatementGridID;
    var bankStatementGridID;
    
    //Grid Properties 설정
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,        
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 35,

            softRemoveRowMode:false
    };
    
    // AUIGrid 칼럼 설정
    var columnLayout = [ 
        {dataField : "crcStateId",headerText : "CRC No.",width : 100 , editable : false},
        {dataField : "bankAccName",headerText : "Bank Account",width : 300 , editable : false},
        {dataField : "crcStateRefDt",headerText : "Transaction<br>Date",width : 100 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "crcTotGrossAmt",headerText : "Gross(RM)",width : 100 , editable : false, dataType:"numeric", formatString:"#,##0.00"},               
        {dataField : "crcStateUploadDt",headerText : "Upload<br>Date",width : 100 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},        
        {dataField : "crcStateUploadUserNm",headerText : "Upload By",width : 240 , editable : false},
        {dataField : "crcBcStusName",headerText : "Cleared<br>Status",width : 240 , editable : false},
        {dataField : "crcStateRem",headerText : "Remark",editable : false}
        ];

    $(document).ready(function(){
    	mappedGridID = GridCommon.createAUIGrid("grid_wrap_mapped_list", columnLayout, null, gridPros);
    	crcStatementGridID = GridCommon.createAUIGrid("grid_wrap_crc_statement", columnLayout, null, gridPros);
    	crcStatementGridID = GridCommon.createAUIGrid("grid_wrap_bank_statement", columnLayout, null, gridPros);
    });
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Credit Card Payment</li>
        <li>Bank Reconciliation between Credit Card Statement & Bank Statement</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Upload Credit Card Statement</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:showUploadPop();">New Upload</a></p></li>            
            <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="tranDateFr" name="tranDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="tranDateTo" name="tranDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th scope="row">BANK Account</th>
                        <td><select id="bankAccount" name="bankAccount"></select></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <h2>Mapped List</h2>
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap_mapped_list" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
    <h2>Un-Mapped List</h2>
    <div class="divine_auto"><!-- divine_auto start -->
	    <div style="width:50%;">
		    <aside class="title_line"><!-- title_line start -->
		      <h3>Credit Card List</h3>
		    </aside><!-- title_line end -->
		    <article id="grid_wrap_crc_statement" class="grid_wrap"></article>
	    </div>
	    <div style="width:50%;">
	        <aside class="title_line"><!-- title_line start -->
	          <h3>Bank Statement</h3>
	        </aside><!-- title_line end -->
	        <article id="grid_wrap_bank_statement" class="grid_wrap"></article>
	    </div>
    </div><!-- divine_auto end -->
    <ul class="right_btns">
        <li><p class="btn_blue2" id="mapping"><a href="#">Mapping</a></p></li>            
        <li><p class="btn_blue2" id="knockOff"><a href="#">Knock-Off</a></p></li>
    </ul>

</section>
<!-- content end -->
