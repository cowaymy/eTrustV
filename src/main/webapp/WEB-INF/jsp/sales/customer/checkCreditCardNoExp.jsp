<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<section id="content">
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Sales</li>
	    <li>Order list</li>
	</ul>

	<aside class="title_line">
	    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	    <h2>Check Credit Card Owner (no Exp)</h2>
		<ul class="right_btns">
		    <li><p class="btn_blue"><a href="#" onClick="searchCreditCardInfo()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
		    <li><p class="btn_blue"><a href="#" onclick="resetForm()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
		</ul>
	</aside>

	<section class="search_table">
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
	                    <input type="text" title="" id="cardNo" name="cardNo" placeholder="Card No" style="width:100%" />
	                </td>
	            </tr>
	        </tbody>
	    </table>
	</form>
	</section>

	<section class="search_result">
		<article class="grid_wrap">
		    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
		</article>
	</section>
</section>

<script>

        const myGridID =   GridCommon.createAUIGrid('list_grid_wrap',[
		{
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
		        showLabel : false,
		        editable : false,
		        checkValue : "Y",
		        unCheckValue : "N",
		        visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField)
		         {
		           return true;
		         }
		    }
         }],'',
        {
               usePaging: true,
               pageRowCount: 50,
               editable: false,
               showRowNumColumn: true,
               wordWrap: true,
               showStateColumn: false
     });

	const searchCreditCardInfo = () => {
		let match = $("#cardNo").val().match(/(\d{6}).*(\d{4})/);
        if(match){
	         Common.showLoader();
	         fetch("/sales/customer/searchCreditCardNoExp.do?grp1=" + match[1] + "&grp2=" + match[2])
	         .then(resp => resp.json())
	         .then(data => {
	             Common.removeLoader();
	             AUIGrid.setGridData(myGridID, data);
	         });
        }else{
        	Common.alert("Only allow to trace order number(s) from the first 6 last 4 card number");
        	return;
        }
	}

	const checkFormat = () => {
		$("#cardNo").unbind().bind("change keyup", function(e) {
            $(this).val($(this).val().replace(/[^\d\s*]+/g, '').trim());
        });
	}

	checkFormat();

    const resetForm = () => {
        document.getElementById("searchForm").reset();
    }


</script>