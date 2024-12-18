<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
.row {
    display : flex;
    align-items : center;
/*     margin-bottom: 15px; */
}

.box {
  height: 20px;
  width: 20px;
/*   border: 1px solid black; */
  margin : 0px 5px;
  border-radius: 5px;
}

.dataBox{
/* 	position: relative; */
}

.box2 {
  height: 20px;
  width: 20px;
/*   border: 1px solid black; */
/*   margin : 0px 5px; */
  border-radius: 5px;
   position: relative;
   /*top: 50%; */
    left: 45%;
/*     transform: translate(-50%, -50%); */
/*     vertical-align : top; */
}

.green {
  background-color: green;
}

.yellow {
  background-color: yellow;
}

.red {
  background-color: red;
}

.black {
  background-color: black;
}

.aui-grid-grey-header{
  background: grey;
  color: black;
}
.aui-grid-green-header{
  background: green;
  color: white;
}
.aui-grid-yellow-header{
  background: yellow;
  color: black;
}
.aui-grid-red-header{
  background: red;
  color: white;
}
.aui-grid-black-header{
  background: black;
  color: white;
}

</style>

<script type="text/javaScript">

    var existUnitHistGridId;
    var newProdEligGridId;

	$(document).ready(function(){
		createAUIGrid();
		createAUIGrid2();

		fn_getPreCcpResultInfo();
	});

function chgTab(tabNm) {
    switch(tabNm) {
        case 'custCredit_info_div' :
            break;
        case 'existUnitHist_info_div' :
            AUIGrid.resize(existUnitHistGridId, 942, 380);
            break;
        case 'newProdElig_info_div' :
            AUIGrid.resize(newProdEligGridId, 942, 380);
            break;
    };
}

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [
        { headerText : 'ORDER NO', dataField : "salesOrdNo", width: '15%'}
      , { headerText : 'PRODUCT<br>CATEGORY', dataField : "prodCat", width: '15%'}
      , { headerText : 'ORDER STATUS', dataField : "ordStus", width: '15%'}
      , { headerText : 'RENTAL STATUS', dataField : "rentStus", width: '15%'}
      , { headerText : 'CARD TYPE', dataField : "cardType", width: '15%'}
      , { headerText : 'TOTAL<br>OUTSTANDING', dataField : "ordTotOtstnd", width: '15%'}
      , { headerText : 'OUTSTANDING<br>MONTH', dataField : "ordOtstndMth", width: '15%'}
      , { headerText : 'UNBILL AMOUNT', dataField : "ordUnbillAmt", width: '15%'}
      , { headerText : 'PENALTY<br>CHARGE', dataField : "totPnaltyChrg", width: '15%'}
      ];

    existUnitHistGridId = GridCommon.createAUIGrid("existUnitHist_grid", columnLayout, "", gridPros);
}

function createAUIGrid2() {
    //AUIGrid 칼럼 설정
    var columnLayout2 = [
        {
        	headerText : 'PRODUCT CATEGORY', dataField : "prodCat", width: '20%',
        	headerStyle: "aui-grid-grey-header",
        }, {
        	headerText : 'RECOMMEND', dataField : "recommend",
        	headerStyle: "aui-grid-green-header",
        	renderer: {
                type: 'TemplateRenderer',
                editable : false,
                height: 10,
            },
        	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                 var retStr;
                 if(value == "REC"){
                     retStr = "<div class='dataBox'><div class='box2 green'></div></div>";
                 }else{
                     retStr = null;
                 }
                 return retStr;
             },
        }, {
            headerText : 'NOT RECOMMENDED', dataField : "recommend",
            headerStyle: "aui-grid-yellow-header",
            renderer: {
                type: 'TemplateRenderer',
                editable : false,
                height: 10,
            },
            labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                var retStr;
                if(value == "NOTREC"){
                    retStr = "<div class='dataBox'><div class='box2 yellow'></div></div>";
                }else{
                    retStr = null;
                }
                return retStr;
            },
        }, {
            headerText : 'ADVANCE PAYMENT', dataField : "recommend",
            headerStyle: "aui-grid-red-header",
            renderer: {
                type: 'TemplateRenderer',
                editable : false,
                height: 10,
            },
            labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                var retStr;
                if(value == "ADVPAY"){
                    retStr = "<div class='dataBox'><div class='box2 red'></div></div>";
                }else{
                    retStr = null;
                }
                return retStr;
            },
        }, {
            headerText : 'NOT ELIGIBLE', dataField : "recommend",
            headerStyle: "aui-grid-black-header",
            renderer: {
                type: 'TemplateRenderer',
                editable : false,
                height: 10,
            },
            labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                var retStr;
                if(value == "NOTELIG"){
                    retStr = "<div class='dataBox'><div class='box2 black'></div></div>";
                }else{
                	retStr = null;
                }
                return retStr;
            },
        }
      ];

    newProdEligGridId = GridCommon.createAUIGrid("newProdElig_grid", columnLayout2, "", gridPros);
}

function fn_getPreCcpResultInfo(){
    Common.ajax("GET", "/sales/ccp/getExistUnitHist.do", {custId : '${custId}'}, function(data) {
        AUIGrid.setGridData(existUnitHistGridId, data);
    });

    var custScore;
    if('${custCredit.chsStus}' != null && '${custCredit.chsStus}' != ''){
    	custScore = '${custCredit.chsStus}';
    }else{
    	custScore = '${custCredit.scoreGrp}';

    	switch('${custCredit.scoreGrp}'){

	    	case 'EXCELLENT SCORE' :
	    		custScore = 'EXCLSCORE';
	    		break;
	    	case 'GOOD SCORE' :
	    		custScore = 'GOODSCORE';
	    		break;
	    	case 'LOW SCORE' :
	    		custScore = 'LOWSCORE';
	    		break;
	    	case 'NO SCORE INSUFFICIENT CCRIS' :
	    		custScore = 'INSUFCCRIS';
	    		break;
	    	case 'NO SCORE' :
	    		custScore = 'NOSCORE';
	    		break;
	    	case 'EXCELLENT' :
	    		custScore = 'EXCL';
	    		break;
	    	case 'GOOD' :
	    		custScore = 'GOOD';
	    		break;
	    	case 'MODERATE' :
	    		custScore = 'MODERATE';
	    		break;
	    	case 'POOR' :
	    		custScore = 'POOR';
	    		break;
    	}
    }

    Common.ajax("GET", "/sales/ccp/getNewProdElig.do", {custScore : custScore}, function(data) {
        AUIGrid.setGridData(newProdEligGridId, data);
    });
}
</script>

<div id="popup_wrap_preCcpResult" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
    <h1>CCP Recommendation</h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" id="closeBtn"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
    <div class="row">
      <div class='box green'></div><span>MOST RECOMMEND</span>
      <div class='box yellow'></div><span>NOT RECOMMEND</span>
      <div class='box red'></div><span>NEED ADVANCE PAYMENT</span>
      <div class='box black'></div><span>NO QUALIFICATIONS</span>
    </div>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <section class="tap_wrap">
            <ul class="tap_type1">
                <li><a id="custCredit_info" href="#" class="on" onClick="chgTab(this.id)">CUSTOMER CREDIBILITY INFO</a></li>
                <li><a id="existUnitHist_info" href="#" onClick="chgTab(this.id)">EXISTING UNIT HISTORY</a></li>
                <li><a id="newProdElig_info" href="#" onClick="chgTab(this.id)">NEW PRODUCT ELIGIBILITY</a></li>
             </ul>

               <!-- CUSTOMER CREDIBILITY INFO TAB -->
            <article class="tap_area" id="custCredit_info_div">
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
					    <col style="width:130px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
						    <th scope="row">CUSTOMER NAME</th>
						    <td><span>${custCredit.name}</span></td>
						</tr>
						<tr>
						    <th scope="row">CUSTOMER TYPE</th>
						    <td><span>${custCredit.custType}</span></td>
						</tr>
						<tr>
						    <th scope="row">CHS STATUS</th>
						    <td><span>${custCredit.chsStus}</span></td>
						</tr>
						<tr>
						    <th scope="row">CHS REASON</th>
						    <td><span>${custCredit.chsRsn}</span></td>
						</tr>
						<tr>
						    <th scope="row">CUSTOMER CATEGORY</th>
						    <td><span>${custCredit.custCat}</span></td>
						</tr>
						<tr>
						    <th scope="row">UNIT ENTITLEMENT</th>
						    <td><span>${custCredit.unitEntitle}</span></td>
						</tr>
						<tr>
						    <th scope="row">SCORE GROUP</th>
						    <td><span>${custCredit.scoreGrp}</span></td>
						</tr>
						<tr>
						    <th scope="row">PRODUCT ENTITLEMENT</th>
						    <td><span>${custCredit.prodEntitle}</span></td>
						</tr>
						<tr>
						    <th scope="row">RENTAL FEE LIMIT PER UNIT</th>
						    <td><span>${custCredit.rentFeeLimit}</span></td>
						</tr>
					</tbody>
				</table>
            </article>

               <!-- EXISTING UNIT HISTORY TAB -->
            <article class="tap_area" id="existUnitHist_info_div">
                 <article class="grid_wrap">
                    <div id="existUnitHist_grid" style="height:70vh"/>
                </article>
            </article>

               <!-- NEW PRODUCT ENTITLEMENT TAB -->
            <article class="tap_area" id="newProdElig_info_div">
                 <article class="grid_wrap">
                    <div id="newProdElig_grid" style="height:70vh"/>
                </article>
            </article>
        </section>

    </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
