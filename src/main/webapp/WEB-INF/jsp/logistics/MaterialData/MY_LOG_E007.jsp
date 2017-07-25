<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}


#editWindow {
    font-size:13px;
}
#editWindow label, input { display:block; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGrid;

    // 등록창
    var insdialog;
    
    // 수정창
    var dialog;
    
    var itemdata;
    
    var comboData = [{"codeId": "1","codeName": "Y"},{"codeId": "8","codeName": "N"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    
    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
    var columnLayout = [{dataField:"itmCode"         ,headerText:"Itm Code"         ,width:120    ,height:30 , visible:true},
                        {dataField:"itmName"         ,headerText:"Itm Name"         ,width:250    ,height:30 , visible:true},
                        {dataField:"itmDesc"         ,headerText:"Itm Desc"         ,width:350    ,height:30 , visible:true},
                        {dataField:"itmId"           ,headerText:"Itm Id"           ,width:140    ,height:30 , visible:false},
                        {dataField:"codeName"        ,headerText:"Code Name"        ,width:"12%"  ,height:30 , visible:true},
                        {dataField:"attachImgLoc"    ,headerText:"Attach Img Loc"    ,width:120    ,height:30 , visible:false},
                        {dataField:"ctgryId"         ,headerText:"Ctgry Id"         ,width:120    ,height:30 , visible:false},
                        {dataField:"isAttachImg"     ,headerText:"IsAttach Img"     ,width:120    ,height:30 , visible:false},
                        {dataField:"isHotItm"        ,headerText:"Hot Itm"        ,width:90     ,height:30 , visible:true},
                        {dataField:"isNwItm"         ,headerText:"New Itm"         ,width:90     ,height:30 , visible:true},
                        {dataField:"isPromoItm"      ,headerText:"Promo Itm"      ,width:120    ,height:30 , visible:true},
                        {dataField:"itemType"        ,headerText:"Item Type"        ,width:100    ,height:30 , visible:false},
                        {dataField:"prc"             ,headerText:"Prc"             ,width:100    ,height:30 , visible:true , dataType:"numeric", formatString : "#.00"},
                        {dataField:"prcRem"          ,headerText:"PrcRem"          ,width:100    ,height:30 , visible:false},
                        {dataField:"promoNormalPrc"  ,headerText:"PromoNormalPrc"  ,width:100    ,height:30 , visible:false},
                        {dataField:"seq"             ,headerText:"Seq"             ,width:100    ,height:30 , visible:false},
                        {dataField:"stusCodeId"      ,headerText:"StusCodeId"      ,width:100    ,height:30 , visible:false},
                        {dataField:"crtDt"           ,headerText:"CrtDt"           ,width:100    ,height:30 , visible:false , formatString : "mm/dd/yyyy"},
                        {dataField:"crtUserId"       ,headerText:"CrtUserId"       ,width:100    ,height:30 , visible:false},
                        {dataField:"updDt"           ,headerText:"UpdDt"           ,width:100    ,height:30 , visible:false},
                        {dataField:"updUserId"       ,headerText:"UpdUserId"       ,width:100    ,height:30 , visible:false},
                        {dataField:"codeId"          ,headerText:"CodeId"          ,width:"8%"   ,height:30 , visible:false},
                        {dataField:"PRD"             ,headerText:"ProductDisplayDummySet"   ,width:"8%"   ,height:30 , visible:true
                        	, renderer : 
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1426", // true, false 인 경우가 기본
                                unCheckValue : ""
                            }
                        },
                        {dataField:"CDTL"               ,headerText:"CodyTools"               ,width:"8%"   ,height:30 , visible:true
                        	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1362", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                        }     
                        },
                        {dataField:"HRI"                  ,headerText:"HRItem"                  ,width:"8%"   ,height:30 , visible:true
                        	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1350", // true, false 인 경우가 기본
	                            unCheckValue : false
	                            
	                           
	                        }
	                                  
	                    },
                        {dataField:"FINI"             ,headerText:"FinanceItem"             ,width:"8%"   ,height:30 , visible:true
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1349", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                           
	                        }
                                  
	                    },
                        {dataField:"MISC"                ,headerText:"MiscItem"                ,width:"8%"   ,height:30 , visible:true
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1348", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                           
	                        }
	                                  
	                    },
                        {dataField:"UNM"                 ,headerText:"Uniform"                 ,width:"8%"   ,height:30 , visible:true
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1347", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                           
	                        }
	                                  
	                    },
                        {dataField:"MKT"         ,headerText:"MerchandiseItem"         ,width:"8%"   ,height:30 , visible:true
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1346", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                           
	                        }
	                                  
	                    },
                        {dataField:"KSK"               ,headerText:"KioskItem"               ,width:"8%"   ,height:30 , visible:true
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1345", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                         }
	                    }
                       ];
    
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false , fixedColumnCount:2};
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doGetCombo('/common/selectCodeList.do', '63', '','spgroup', 'A' , ''); 
        doDefCombo(comboData, '' ,'sused', 'A', '');
        
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {   
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
        });
        
        AUIGrid.bind(myGridID, "ready", function(event) {
        	var rowCount = AUIGrid.getRowCount(myGridID);  
        	
        	for (var i = 0 ; i < rowCount ; i++){
        		var itemtype = AUIGrid.getCellValue(myGridID, i, "itemType");
        		
        		if (itemtype != null && itemtype != "" && itemtype != undefined){
        			
        			var typeArr = itemtype.split(",");
        			for (var j = 0 ; j < typeArr.length ; j++){
        				
        				$.each(itemdata, function(index,value) {
        					if(typeArr[j] == itemdata[index].codeId ){
        						AUIGrid.setCellValue(myGridID, i, itemdata[index].code , typeArr[j]);
        					}
       			        });
        				
        			}
        		}
        	}
        	AUIGrid.resetUpdatedItems(myGridID, "all");
        });
        
         $("#detailView").hide();

    });

    $(function(){
    	$('#svalue').keypress(function(event) {
    		if (event.which == '13') {
            	$("#sUrl").val("/logistics/material/materialcdsearch.do");
            	Common.searchpopupWin("searchForm", "/common/searchPopList.do","item");
            }
        });
    	$("#search").click(function(){
            getMaterialListAjax();
            $("#detailView").hide();
        });
        $("#clear").click(function(){
            doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
            doDefCombo(comboData, '' ,'status', 'S', '');
            $("#loccd").val('');
            $("#locdesc").val('');
        });
        $("#update").click(function(){
            
            console.log(GridCommon.getEditData(myGridID).update.length);
            var updCnt = GridCommon.getEditData(myGridID).update.length;
            for (var i = 0 ; i < updCnt ; i++){
                var make = GridCommon.getEditData(myGridID).update[i];
                console.log(make);
                var itemtypevalue = "";
                if (make.CDTL != undefined && make.CDTL != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.CDTL; 
                }
                if (make.FINI != undefined && make.FINI != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.FINI; 
                }if (make.HRI != undefined && make.HRI != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.HRI; 
                }
                if (make.KSK != undefined && make.KSK != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.KSK; 
                }if (make.MKT != undefined && make.MKT != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.MKT; 
                }
                if (make.MISC != undefined && make.MISC != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.MISC; 
                }if (make.PRD != undefined && make.PRD != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.PRD; 
                }
                if (make.UNM != undefined && make.UNM != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.UNM; 
                }
                
                console.log(itemtypevalue);
            }
            
            
       
//                 $.each(itemdata, function(index,value) {
//                     if(typeArr[j] == itemdata[index].codeId ){
//                         AUIGrid.setCellValue(myGridID, i, itemdata[index].code , typeArr[j]);
//                     }
//                 });
//             }
            
//         	Common.ajax("POST", "/logistics/material/materialUpdate.do", GridCommon.getEditData(myGridID), function(result) {
//                 Common.alert(result.message);
//                 AUIGrid.resetUpdatedItems(myGridID, "all");
                
//             },  function(jqXHR, textStatus, errorThrown) {
//                 try {
//                 } catch (e) {
//                 }

//                 Common.alert("Fail : " + jqXHR.responseJSON.message);
//             });
        });
        $(".numberAmt").keyup(function(e) {
            regex = /[^.0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
        });
        $("#delete").click(function(){
        	var selectedItems = AUIGrid.getSelectedItems(myGridID);
        	for (var i = 0 ; i < selectedItems.length ; i++){
        		   AUIGrid.removeRow(myGridID, selectedItems[i].rowIndex);
        	}
        	Common.ajax("POST", "/logistics/material/materialUpdate.do", GridCommon.getEditData(myGridID), function(result) {
                Common.alert(result.message);
                AUIGrid.resetUpdatedItems(myGridID, "all");
                
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }

                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        });
        

    });
    
    function fn_itempop(cd , nm , ct , tp){
    	doGetCombo('/common/selectCodeList.do', '63', ct ,'spgroup', 'A' , '');
    	$("#svalue").val(cd);
        $("#sname").text(nm);
    }
    
    function getMaterialListAjax() {
        f_showModal();
        var url = "/logistics/material/materialitemList.do";
        var param = $('#searchForm').serializeJSON();
        $.ajax({
            type : "GET",
            url : "/common/selectCodeList.do",
            data : { groupCode : "141"},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                itemdata = data;
            },
            error: function(jqXHR, textStatus, errorThrown){
            },
            complete: function(){
            }
        });
        Common.ajax("POST" , url , param , function(data){
        	
            /*if(AUIGrid.isCreated(myGridID)) {
                AUIGrid.destroy(myGridID);
            }*/
            //AUIGrid.destroy(myGridID);
            //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
            AUIGrid.setGridData(myGridID, data.data);
            hideModal();
        });
    }
    
    function f_showModal(){
        $.blockUI.defaults.css = {textAlign:'center'}
        $('div.SalesWorkDiv').block({
                message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' /><div class='preloader'><i id='iloader'>.</i><i id='iloader'>.</i><i id='iloader'>.</i></div>",
                centerY: false,
                centerX: true,
                css: { top: '300px', border: 'none'} 
        });
    }
    function hideModal(){
        $('div.SalesWorkDiv').unblock();
        
    }
    
</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Material Master</li>
    <li>Non-Valued Item</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Non-Valued Item</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<input type="hidden" id="sUrl" name="sUrl">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Code</th>
    <td><input type="text" id="svalue" name="svalue" class="w100p"/><p id='sname'></td>
    <th scope="row">Key Product Group</th>
    <td>
    <select class="w100p" id="spgroup"></select>
    </td>
    <th scope="row">Used</th>
    <td>
    <select class="w100p" id="sused"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
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
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside>

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<div id="detailView">
<aside class="title_line"><!-- title_line start -->
<h3 id="title">Material Master Create/Change</h3>
</aside>
<aside class="title_line"><!-- title_line start -->
<h4>Main Value</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Code</th>
    <td>
    <input type="text" placeholder="" class="readonly w100p" readonly="readonly" />
    </td>
    <th scope="row">Description</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Old Material Number</th>
    <td>
    <input type="text" placeholder="" class="w100p" readonly="" />
    </td>
    <th scope="row">Material Code</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Material Code</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Key Product Group</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Sales Price</th>
    <td>
    <input type="text" placeholder="" class="w100p" readonly="" />
    </td>
    <th scope="row">Used</th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h4>Item Type</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:225px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Item Type 1(Kiosk)</th>
    <td>
    <label><input type="checkbox" /></label>
    </td>
    <th scope="row">Item Type 2Merchandise)</th>
    <td>
    <label><input type="checkbox" /></label>
    </td>
    <th scope="row">Item Type 3(Uniform)</th>
    <td colspan="3">
    <label><input type="checkbox" /></label>
    </td>
</tr>
<tr>
    <th scope="row">Item Type 4(Misc Item)</th>
    <td>
    <label><input type="checkbox" /></label>
    </td>
    <th scope="row">Item Type 5(Cody Tool)</th>
    <td>
    <label><input type="checkbox" /></label>
    </td>
    <th scope="row">Item Type 6(Finance Item)</th>
    <td>
    <label><input type="checkbox" /></label>
    </td>
    <th scope="row">Item Type 7(HR Item)</th>
    <td>
    <label><input type="checkbox" /></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</div>
</section>
