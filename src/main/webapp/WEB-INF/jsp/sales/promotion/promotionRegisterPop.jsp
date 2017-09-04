<script type="text/javaScript" language="javascript">

  	//AUIGrid 생성 후 반환 ID
	var stckGridID, giftGridID;
	
    $(document).ready(function(){

        //AUIGrid 그리드를 생성합니다.
        createAUIGridStk();
        
        doGetCombo('/common/selectCodeList.do', '320', '',       'promoAppTypeId', 'S'); //Promo Application
        doGetCombo('/common/selectCodeList.do',  '76', '',          'promoTypeId', 'S'); //Promo Type
        doGetCombo('/common/selectCodeList.do',  '8', '',        'promoCustType', 'S'); //Customer Type
        doGetComboData('/common/selectCodeList.do', {groupCode :'325'}, '',              'exTrade', 'S'); //EX_Trade
        doGetComboData('/common/selectCodeList.do', {groupCode :'324'}, '',               'empChk', 'S'); //EMP_CHK
        doGetComboData('/common/selectCodeList.do', {groupCode :'323'}, '',        'promoDiscType', 'S'); //Discount Type
        doGetCombo('/common/selectCodeList.do', '322', '',    'promoDiscPeriodTp', 'S'); //Discount period
        doGetComboData('/common/selectCodeList.do', {groupCode :'321'}, '', 'promoFreesvcPeriodTp', 'S'); //Free SVC Period
        
        doGetCombo('/sales/promotion/selectMembershipPkg.do', '', '9', 'promoSrvMemPacId', 'S'); //Common Code
    });
    
    function createAUIGridStk() {
        
    	//AUIGrid 칼럼 설정
        var columnLayout1 = [
            { headerText : "Product CD",    dataField  : "itmcd",   editable : false,   width : 100 }
          , { headerText : "Product Name",  dataField  : "itmname", editable : false                  }
          , { headerText : "Normal" 
            , children   : [{ headerText : "Monthly Fee<br>/Price", dataField : "amt",          editable : false, width : 100  }
                          , { headerText : "RPF",                   dataField : "prcRpf",       editable : false, width : 100  }
                          , { headerText : "PV",                    dataField : "prcPv",        editable : false, width : 100  }]}
          , { headerText : "Promotion" 
            , children   : [{ headerText : "Monthly Fee<br>/Price", dataField : "promoAmt",     editable : false, width : 100  }
                          , { headerText : "RPF",                   dataField : "promoPrcRpf",  editable : false, width : 100  }
                          , { headerText : "PV",                    dataField : "promoItmPv",   editable : true,  width : 100  }]}
          , { headerText : "itmid",         dataField   : "promoItmStkId",  visible  : false,     width : 80  }
          ];

    	//AUIGrid 칼럼 설정
        var columnLayout2 = [
            { headerText : "Product CD",    dataField : "itmcd",    editable : false,   width : 100 }
          , { headerText : "Product Name",  dataField : "itmname",  editable : false                }
          , { headerText : "itmid",         dataField : "promoFreeGiftStkId", visible  : false,   width : 120 }
          ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells", 
            showRowCheckColumn  : true,
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        stckGridID = GridCommon.createAUIGrid("pop_stck_grid_wrap", columnLayout1, "", gridPros);
        giftGridID = GridCommon.createAUIGrid("pop_gift_grid_wrap", columnLayout2, "", gridPros);
    }
    
    function fn_doSavePromtion() {
        console.log('!@# fn_doSavePromtion START');
        
        var promotionVO = {
            
            salesPromoMVO : {
	            promoCode               : $('#promoCode').val().trim(),
	            promoDesc               : $('#promoDesc').val().trim(),
	            promoTypeId             : $('#promoTypeId').val(),
	            promoAppTypeId          : $('#promoAppTypeId').val(),
	            promoSrvMemPacId        : $('#promoSrvMemPacId').val(),
	            promoDtFrom             : $('#promoDtFrom').val().trim(),
	            promoDtEnd              : $('#promoDtEnd').val().trim(),
	            promoPrcPrcnt           : $('#promoDiscValue').val().trim(),
	            promoCustType           : $('#promoCustType').val().trim(),
	            promoDiscType           : $('#promoDiscType').val(),
//	            promoRpfDiscAmt         : $('#promoRpfDiscAmt').val(),
	            promoRpfDiscAmt         : fn_getDiscountRPF(),
	            promoDiscPeriodTp       : $('#promoDiscPeriodTp').val(),
	            promoDiscPeriod         : $('#promoDiscPeriod').val().trim(),
	            promoFreesvcPeriodTp    : $('#promoFreesvcPeriodTp').val(),
	            promoAddDiscPrc         : $('#promoAddDiscPrc').val().trim(),
	            promoAddDiscPv          : $('#promoAddDiscPv').val().trim(),
	            empChk                  : $('#exTrade').val(),
	            exTrade                 : $('#empChk').val()
            },
            salesPromoDGridDataSetList  : GridCommon.getEditData(stckGridID),
            freeGiftGridDataSetList     : GridCommon.getEditData(giftGridID)
        };

        Common.ajax("POST", "/sales/promotion/registerPromotion.do", promotionVO, function(result) {

            Common.alert("New Promotion Saved" + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);

                Common.alert("Failed To Save" + DEFAULT_DELIMITER + "<b>Failed to save order.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
            }
            catch (e) {
                console.log(e);
//              alert("Saving data prepration failed.");
            }

//          alert("Fail : " + jqXHR.responseJSON.message);
        });
    }
    
    function fn_calcDiscountPrice() {
        
        var discType     = $('#promoDiscType').val();
        var discValue    = FormUtil.isEmpty($('#promoDiscValue').val()) ? 0 : $('#promoDiscValue').val().trim();
        var addDiscValue = FormUtil.isEmpty($('#promoAddDiscPrc').val()) ? 0 : $('#promoAddDiscPrc').val().trim();
        var normalDiscValue = 0, promoDiscValue = 0;
        
        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {
            
            normalDiscValue = AUIGrid.getCellValue(stckGridID, i, "amt");
            
            if(discType == '2296') {//%
                promoDiscValue = Math.floor(normalDiscValue - normalDiscValue * (discValue / 100));
            }
            else if(discType == '2297') { //Amount
                promoDiscValue = normalDiscValue - discValue;
            }
            else {
                promoDiscValue = normalDiscValue;
            }
            
            promoDiscValue -= addDiscValue;
            
            AUIGrid.setCellValue(stckGridID, i, "promoAmt", promoDiscValue);
        }
    }
    
    function fn_calcDiscountRPF() {
        var discRpfValue = FormUtil.isEmpty($('#promoRpfDiscAmt').val()) ? 0 : $('#promoRpfDiscAmt').val().trim();
        var normalDiscRpfValue = 0, promoDiscRpfValue = 0;
        
        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {
            
            normalDiscRpfValue = AUIGrid.getCellValue(stckGridID, i, "prcRpf");
            
            promoDiscRpfValue = normalDiscRpfValue - discRpfValue;
            
            AUIGrid.setCellValue(stckGridID, i, "promoPrcRpf", promoDiscRpfValue);
        }
    }
    
    function fn_calcDiscountPV() {
        var discPvValue = FormUtil.isEmpty($('#promoAddDiscPv').val()) ? 0 : $('#promoAddDiscPv').val().trim();
        var normalDiscPvValue = 0, promoDiscPvValue = 0;
        
        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {
            
            normalDiscPvValue = AUIGrid.getCellValue(stckGridID, i, "prcPv");
            
            promoDiscPvValue = normalDiscPvValue - discPvValue;
            
            AUIGrid.setCellValue(stckGridID, i, "promoPrcPv", promoDiscPvValue);
        }
    }
    
    function fn_getDiscountRPF() {
        var exTradeValue = $('#exTrade').val();
        var prdRFPVal = 0
        
        for(var i = 0; i < AUIGrid.getRowCount(stckGridID) ; i++) {            
            prdRFPVal = prdRFPVal + FormUtil.isEmpty(AUIGrid.getCellValue(stckGridID, i, "prcRpf") ? 0 : AUIGrid.getCellValue(stckGridID, i, "prcRpf"));
        }
        
        if(exTradeValue != '1') {
            prdRFPVal = FormUtil.nvl($('#promoRpfDiscAmt'));
        }
        
        return prdRFPVal;
    }
    
    function fn_getPrdPriceInfo() {
         
        var promotionVO = {            
            salesPromoMVO : {
	            promoAppTypeId         : $('#promoAppTypeId').val()
            },
            salesPromoDGridDataSetList : GridCommon.getEditData(stckGridID)
        };

        Common.ajax("POST", "/sales/promotion/selectPriceInfo.do", promotionVO, function(result) {

            var arrGridData = AUIGrid.getGridData(stckGridID);
            
            for(var i = 0; i < result.length; i++) {
                for(var j = 0; j < AUIGrid.getRowCount(stckGridID) ; j++) {
                    var stkId = AUIGrid.getCellValue(stckGridID, j, "promoItmStkId");
                    if(stkId == result[i].promoItmStkId) {
                        AUIGrid.setCellValue(stckGridID, j, "amt",    result[i].amt);
                        AUIGrid.setCellValue(stckGridID, j, "prcRpf", result[i].prcRpf);
                        AUIGrid.setCellValue(stckGridID, j, "prcPv",  result[i].prcPv);
                    }
                }
            }
            
            fn_calcDiscountPrice();
            
            fn_calcDiscountRPF();
            
            fn_calcDiscountPV();
        });
    }
    
    $(function(){
        $('#btnProductAdd').click(function() {
            Common.popupDiv("/sales/promotion/promotionProductPop.do", {gubun : "stocklist"});
        });
        $('#btnProductDel').click(function() {
            fn_getPrdPriceInfo();
        });
        $('#btnFreeGiftAdd').click(function() {
        	Common.popupDiv("/sales/promotion/promotionProductPop.do", {gubun : "item"});
        });
        $('#promoAppTypeId').change(function() {
        	fn_chgPromoDetail();
        });
        $('#promoTypeId').change(function() {
        	fn_chgPromoDetail();
        });
        $('#promoCustType').change(function() {
        	fn_chgPromoDetail();
        });
        $('#promoDiscType').change(function() {
            if($('#promoDiscType').val() == '') {
                $('#promoDiscValue').val('').prop("disabled", true);
            }
            else {
                $('#promoDiscValue').val('').removeAttr("disabled");
            }
            
            fn_calcDiscountPrice();
        });
        $('#promoDiscValue').change(function() {
            fn_calcDiscountPrice();
        });
        $('#promoAddDiscPrc').change(function() {
            fn_calcDiscountPrice();
        });
        $('#promoRpfDiscAmt').change(function() {
            fn_calcDiscountRPF();
        });
        $('#promoAddDiscPv').change(function() {
            fn_calcDiscountPV();
        });
        $('#exTrade').change(function() {
            if($('#exTrade').val() == '1') {
                $('#promoRpfDiscAmt').val('').prop("disabled", true);
            }
            else if($('#exTrade').val() == '0') {
                $('#promoRpfDiscAmt').removeAttr("disabled");
            }
        });
        $('#btnPromoSave').click(function() {
        	fn_doSavePromtion();
        });
    });
    
    function fn_addItems(data, gubun){
    	
        var rowList = [];
       	var vGrid = gubun == "stocklist" ? stckGridID : giftGridID;
       	
       	var lastPos = AUIGrid.getRowCount(stckGridID);
       	
       	for (var i = 0 ; i < data.length ; i++){
        	if(gubun == "stocklist") {
        	    rowList[i] = {
    	    	    promoItmStkId      : data[i].item.itemid,
        	    	itmcd              : data[i].item.itemcode,
        	    	itmname            : data[i].item.itemname,
        	    	amt                : 0,
        	    	prcRpf             : 0,
        	    	prcPv              : 0
        	    }
        	} else {
        	    rowList[i] = {
    	    	    promoFreeGiftStkId : data[i].item.itemid,
        	    	itmcd              : data[i].item.itemcode,
        	    	itmname            : data[i].item.itemname
        	    }
        	}
    	}
        
        AUIGrid.addRow(vGrid, rowList, lastPos);
        
        fn_getPrdPriceInfo();
    }
    
    //TODO Outlight Plus(2287) 선택시 빠져있음
    function fn_chgPromoDetail() {
        var promoAppVal = $('#promoAppTypeId').val();
        var promoTypVal = $('#promoTypeId').val();
        var promoCustVal = $('#promoCustType').val();
        
        //Promo Application = Rental / Outright / Outright Plus
        if(promoAppVal == '2284'|| promoAppVal == '2285'|| promoAppVal == '2287') {
            $('#exTrade').removeAttr("disabled");
        }
        else {
            $('#exTrade').val('').prop("disabled", true);
        }
        
        //Promo Application <> Expired Filter & Customer = Individual
        if(promoAppVal != '2290' && promoCustVal == '964') {
            $('#empChk').removeAttr("disabled");
        }
        else {
            $('#empChk').val('').prop("disabled", true);
        }
        
        //Promo Application = Rental & Promotion Type = Discount
        if(promoAppVal == '2284' && promoTypVal == '2282') {
            console.log('Promo Application = Rental & Promotion Type = Discount');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').removeAttr("disabled");
            $('#promoDiscPeriod').removeAttr("disabled");
            $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
            $('#promoSrvMemPacId').val('').prop("disabled", true);
            
            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = Outright & Promotion Type = Discount
        else if((promoAppVal == '2285' || promoAppVal == '2286') && promoTypVal == '2282') {
            console.log('Promo Application = Outright & Promotion Type = Discount');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
            $('#promoFreesvcPeriodTp').removeAttr("disabled");
            $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').removeAttr("disabled");
            $('#promoSrvMemPacId').val('').prop("disabled", true);
            
            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = Rental/Outright Membership & Promotion Type = Discount
        else if((promoAppVal == '2289' || promoAppVal == '2288') && promoTypVal == '2282') {
            console.log('Promo Application = Rental/Outright Membership & Promotion Type = Discount');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
            $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').val('').prop("disabled", true);
            $('#promoSrvMemPacId').removeAttr("disabled");
            
            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = Expired Filter & Promotion Type = Discount
        else if(promoAppVal == '2290' && promoTypVal == '2282') {
            console.log('Promo Application = Expired Filter & Promotion Type = Discount');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
            $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
            $('#promoSrvMemPacId').val('').prop("disabled", true);
            
            $('#sctPromoDetail').removeClass("blind");
        }
        //Promo Application = ALL (Exclude Expired Filter) & Promotion Type = Only Free Gift
        else if(promoAppVal != '' && promoTypVal == '2283') {
            console.log('Promo Application = ALL (Exclude Expired Filter) & Promotion Type = Only Free Gift');
            
            $('#promoDiscType').val('').prop("disabled", true);
          //$('#promoDiscValue').val('').prop("disabled", true);
            $('#promoRpfDiscAmt').val('').prop("disabled", true);
            $('#promoDiscPeriodTp').val('').prop("disabled", true);
            $('#promoDiscPeriod').val('').prop("disabled", true);
            $('#promoFreesvcPeriodTp').val('').prop("disabled", true);
            $('#promoAddDiscPrc').val('').prop("disabled", true);
            $('#promoAddDiscPv').val('').prop("disabled", true);
            $('#promoSrvMemPacId').val('').prop("disabled", true);
            
            $('#sctPromoDetail').addClass("blind");
        }
        else {
            console.log('etc');
            
            $('#promoDiscType').removeAttr("disabled");
          //$('#promoDiscValue').removeAttr("disabled");
            $('#promoRpfDiscAmt').removeAttr("disabled");
            $('#promoDiscPeriodTp').removeAttr("disabled");
            $('#promoDiscPeriod').removeAttr("disabled");
            $('#promoFreesvcPeriodTp').removeAttr("disabled");
            $('#promoAddDiscPrc').removeAttr("disabled");
            $('#promoAddDiscPv').removeAttr("disabled");
            $('#promoSrvMemPacId').removeAttr("disabled");
            
            $('#sctPromoDetail').removeClass("blind");
        }
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Promotion Management – NEW promotion</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
<!--
	<li><p class="btn_blue2"><a href="#">Product</a></p></li>
	<li><p class="btn_blue2"><a href="#">From Gift</a></p></li>
-->
	<li><p class="btn_blue"><a id="btnPromoSave" href="#">Save</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>Promotion Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Promo Application<span class="must">*</span></th>
	<td>
	<select id="promoAppTypeId" name="promoAppTypeId" class="w100p"></select>
	</td>
	<th scope="row">Promotion Type<span class="must">*</span></th>
	<td>
	<select id="promoTypeId" name="promoTypeId" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row">Promotion Period<span class="must">*</span></th>
	<td colspan="3">
	<div class="date_set w100p"><!-- date_set start -->
	<p><input id="promoDtFrom" name="promoDtFrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input id="promoDtEnd" name="promoDtEnd" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row">Promotion Name</th>
	<td><input id="promoDesc" name="promoDesc" type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Promotion Code</th>
	<td><input id="promoCode" name="promoCode" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Customer Type<span class="must">*</span></th>
	<td>
	<select id="promoCustType" name="promoCustType" class="w100p"></select>
	</td>
	<th scope="row">Ex-Trade<span class="must">*</span></th>
	<td>
	<select id="exTrade" name="exTrade" class="w100p" disabled></select>
	</td>
	<th scope="row">Employee<span class="must">*</span></th>
	<td>
	<select id="empChk" name="empChk" class="w100p" disabled></select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<section id="sctPromoDetail">
<aside class="title_line"><!-- title_line start -->
<h2>Promotion Detail</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Discount(Type/Value)<span class="must">*</span></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p>
	<select id="promoDiscType" name="promoDiscType" class="w100p"></select>
	</p>
	<p>
	<input id="promoDiscValue" name="promoDiscValue" type="text" title="" placeholder="" class="w100p" disabled />   
	</p>
	</div>    
	</td>
	<th scope="row">RPF Discunt<span class="must">*</span></th>
	<td>
	<input id="promoRpfDiscAmt" name="promoRpfDiscAmt" type="text" title="" placeholder="" class="w100p" disabled />
	</td>
</tr>
<tr>
	<th scope="row">Discount period<span class="must">*</span></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p>
	<select id="promoDiscPeriodTp" name="promoDiscPeriodTp" class="w100p"></select>
	</p>
	<p>
	<input id="promoDiscPeriod" name="promoDiscPeriod" type="text" title="" placeholder=""  class="w100p" />   
	</p>
	</div> 
	
	</td>
	<th scope="row">Free SVC Period<span class="must">*</span></th>
	<td>
	<select id="promoFreesvcPeriodTp" name="promoFreesvcPeriodTp" class="w100p"></select>
	</td>
</tr>
<tr>
	<th scope="row">Additional Discount (RM)</th>
	<td><input id="promoAddDiscPrc" name="promoAddDiscPrc" type="text" title="" placeholder="" class="w100p" /></td>
	<th scope="row">Additional Discount (PV)</th>
	<td><input id="promoAddDiscPv" name="promoAddDiscPv" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row">Membership Package<span class="must">*</span></th>
	<td>
	<select id="promoSrvMemPacId" name="promoSrvMemPacId" class="w100p"></select>
	</td>
	<th scope="row"></th>
	<td></td>
</tr>
</tbody>
</table><!-- table end -->
</section>

<aside class="title_line"><!-- title_line start -->
<h2>Product List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
	<li><p class="btn_grid"><a id="btnProductDel" href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a id="btnProductAdd" href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Free Gift List</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
	<li><p class="btn_grid"><a id="btnFreeGiftDel" href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a id="btnFreeGiftAdd" href="#">ADD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_gift_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->