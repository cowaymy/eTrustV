<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var cpGridID;
    var filterGrid;
    var spareGrid;
    var serviceGrid;
    var imgGrid;
    
    var priceHistoryGrid;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "7","codeName": "Obsolete"},{"codeId": "8","codeName": "Inactive"}];
    
    
    var srvMembershipList = new Array();
    
    // 등록창
    var regDialog;
    
    // 수정창
    var dialog;
    
    
    var gridNm;
    var chkNum;// 그리드 체크
    
    
    // AUIGrid 칼럼 설정
    
    var columnLayout = [{dataField:"stkid"             ,headerText:"StockID"           ,width:120 ,height:30, visible : false},
                        {dataField:"stkcode"           ,headerText:"MaterialCode"         ,width:100 ,height:30},
                        {dataField:"stkdesc"           ,headerText:"MaterialName"         ,width:350 ,height:30,style :"aui-grid-user-custom-left"},
                        {dataField:"stkcategoryid"     ,headerText:"CategoryID"      ,width:120,height:30 , visible : false},
                        {dataField:"codename"          ,headerText:"Category"      ,width:140 ,height:30},
                        {dataField:"stktypeid"         ,headerText:"TypeID"          ,width:120 ,height:30, visible : false},
                        {dataField:"codename1"         ,headerText:"Type"          ,width:120 ,height:30},
                        {dataField:"name"              ,headerText:"Status"    ,width:120 ,height:30},
                        {dataField:"statuscodeid"      ,headerText:"statuscodeid"    ,width:120 ,height:30 , visible : false},
                        {dataField:"issirim"           ,headerText:"IsSirim"           ,width:90 ,height:30},
                        {dataField:"isncv"             ,headerText:"IsNCV"             ,width:90 ,height:30},
                        {dataField:"qtypercarton"      ,headerText:"Qty Per Carton" ,width:120 ,height:30},
                        {dataField:"netweight"         ,headerText:"Net Wgt"         ,width:100 ,height:30},
                        {dataField:"grossweight"       ,headerText:"Gross Wgt"       ,width:100 ,height:30},
                        {dataField:"measurementcbm"    ,headerText:"CBM"    ,width:100 ,height:30},
                        {dataField:"stkgrade"          ,headerText:"Grade"        ,width:100 ,height:30},
                        {dataField:"c6"                ,headerText:"STK_COMM_AS"        ,width:100 ,height:30},
                        {dataField:"c7"                ,headerText:"STK_COMM_OS_AS"        ,width:100 ,height:30},
                        {dataField:"c8"                ,headerText:"STK_COMM_BS"        ,width:100 ,height:30},
                        {dataField:"c9"                ,headerText:"STK_COMM_OS_BS"        ,width:100 ,height:30},
                        {dataField:"c10"               ,headerText:"STK_COMM_INS"        ,width:100 ,height:30},
                        {dataField:"c11"               ,headerText:"STK_COMM_OS_INS"        ,width:100 ,height:30}
                       ];

    var filtercolumn = [{dataField:"stockid"             ,headerText:"StockID"       ,width:120 , visible : false},
                        {dataField:"stockname"           ,headerText:"Description"   ,width:"50%", editable : false,style :"aui-grid-user-custom-left"},
                        {dataField:"stock"               ,headerText:"Desc"   ,width:"20%" , visible : false},
                        {dataField:"typeid"              ,headerText:"Type"          ,width:120 , visible : false},
                        {dataField:"typenm"              ,headerText:"TypeName"      ,width:"10%", editable : false,style :"aui-grid-user-custom-left"},
                        {dataField:"period"              ,headerText:"Period"        ,width:"10%", editable : false},
                        {dataField:"qty"                 ,headerText:"Qty"           ,width:"7%", editable : false},
                        {
                            dataField : "",
                            headerText : "",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Remove",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                    gridNm = filterGrid;
                                    chkNum =1;
                                   removeRow(rowIndex, gridNm,chkNum);
                                }
                            }
                        , editable : false
                        }];

  var sparecolumn = [{dataField:"stockid"             ,headerText:"StockID"       ,width:120 , visible : false},
                        {dataField:"stockname"           ,headerText:"Description"   ,width:"70%", editable : false,style :"aui-grid-user-custom-left"},
                        {dataField:"qty"                 ,headerText:"Qty"           ,width:"20%", editable : false},
                        {
                            dataField : "",
                            headerText : "",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Remove",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                    gridNm = spareGrid;
                                    chkNum =2;
                                   removeRow(rowIndex, gridNm,chkNum);
                                }
                            }
                        , editable : false
                        }]; 
    
var servicecolumn = [{dataField:"packageid"           ,headerText:"PACKAGEID"     ,width:120 , visible : false},
                     {dataField:"packagename"         ,headerText:"Description"   ,width:"70%",  style :"aui-grid-user-custom-left", 
                      labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
                     var retStr = "";
                     for (var i = 0, len = srvMembershipList.length; i < len; i++) {
                         if (srvMembershipList[i]["pacid"] == value) {
                             retStr = srvMembershipList[i]["cdname"];
                             break;
                         }
                     }
                     return retStr == "" ? value : retStr;
                 }, 
               editRenderer : {
                   type : "ComboBoxRenderer",
                   showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                   listFunction : function(rowIndex, columnIndex, item, dataField) {
                       return srvMembershipList ;
                   },
                   keyField : "pacid",
                   valueField : "cdname"
                               }
                     },
                     {dataField:"chargeamt"           ,headerText:"Qty"           ,width:"15%"  
                         ,dataType : "numeric",
                         editRenderer : {
                             type : "InputEditRenderer",
                             onlyNumeric : true // Input 에서 숫자만 가능케 설정
                            /*  // 에디팅 유효성 검사
                             validator : function(oldValue, newValue, item) {
                                 var isValid = false;
                                 var numVal = Number(newValue);
                                 if(!isNaN(numVal) && numVal > 10000) {
                                     isValid = true;
                                 }
                                 // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                                 return { "validate" : isValid, "message"  : "10,000 보다 큰 수를 입력하세요." };
                             }*/
                         }    
                     
                     },
                     {
                         dataField : "",
                         headerText : "",
                         renderer : {
                             type : "ButtonRenderer",
                             labelText : "Remove",
                             onclick : function(rowIndex, columnIndex, value, item) {
                                 gridNm = serviceGrid;
                                 chkNum=3;
                                 removeRow(rowIndex, gridNm,chkNum);
                             }
                         }
                     , editable : false
                     }
                    
                     ];
    

    var stockimgcolumn =[{dataField : "imgurl",        headerText : "",   prefix : "/resources", 
                            renderer : { type : "ImageRenderer", imgHeight : 24//, // 이미지 높이, 지정하지 않으면 rowHeight에 맞게 자동 조절되지만 빠른 렌더링을 위해 설정을 추천합니다.
                            //altField : "country" // alt(title) 속성에 삽입될 필드명, 툴팁으로 출력됨
                          }},
                          {dataField:"codenm"         ,headerText:"Angle"     ,width:200 },
                          {dataField : "undefined"    ,headerText:"Preview",
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Show Image",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                    $("#imgShow").html("<img src='/resources"+item.imgurl+"' width='250px' height='250px'>")
                                }
                                }
                          },
                          {dataField:"angeid"         ,headerText:"angeid"    ,width:120 , visible : false},
                          {dataField:"scodeid"        ,headerText:"scodeid"   ,width:120 , visible : false},
                          {dataField:"stkid"          ,headerText:"stkid"     ,width:120 , visible : false},
                          {dataField:"imgid"          ,headerText:"imgid"     ,width:120 , visible : false},
                          {dataField:"udate"          ,headerText:"udate"     ,width:120 , visible : false},
                          {dataField:"uuser"          ,headerText:"uuser"     ,width:120, visible : false},
                          {dataField:"cdate"          ,headerText:"cdate"     ,width:120, visible : false},
                          {dataField:"cuser"          ,headerText:"cuser"     ,width:120 , visible : false}];
    
    var pricehiscolumn=[
                                {dataField:"pricecost"          ,headerText:"Cost"               ,width:"14%" , visible : true},
                                {dataField:"amt"          ,headerText:"Normal Price"     ,width:"14%" , visible : true},
                                {dataField:"pricepv"          ,headerText:"Point of <br> Value (PV)"     ,width:"15%" , visible : true},
                                {dataField:"mrental"          ,headerText:"Monthly <br> Rental"     ,width:"14%" , visible : true},
                                {dataField:"pricerpf"          ,headerText:"Rental <br> Deposit"     ,width:"14%" , visible : true},
                                {dataField:"penalty"          ,headerText:"Penalty <br> Charges"     ,width:"14%" , visible : true},
                                {dataField:"tradeinpv"          ,headerText:"Trade In <br> (PV) Value"     ,width:"15%" , visible : true},
                               ];

 // 그리드 속성 설정
    var gridPros = {
        // 페이지 설정
        usePaging : true,               
        pageRowCount : 30,              
        fixedColumnCount : 1,
        // 편집 가능 여부 (기본값 : false)
        editable : false,                
        // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
        enterKeyColumnBase : true,                
        // 셀 선택모드 (기본값: singleCell)
        selectionMode : "multipleCells",                
        // 컨텍스트 메뉴 사용 여부 (기본값 : false)
        useContextMenu : true,                
        // 필터 사용 여부 (기본값 : false)
        enableFilter : true,            
        // 그룹핑 패널 사용
        useGroupingPanel : true,                
        // 상태 칼럼 사용
        showStateColumn : true,                
        // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
        displayTreeOpen : true,                
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",                
        groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",                
        //selectionMode : "multipleCells",
        //rowIdField : "stkid",
        enableSorting : true,
        showRowCheckColumn : true,

    };
    
    var subgridpros = {
                        // 페이지 설정
                        usePaging : true,                
                        pageRowCount : 10,                
                        editable : true,                
                        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
                        enableSorting : true,
                        softRemoveRowMode:false
                        };
    var subgridpros2 = {
                        // 페이지 설정
                        usePaging : true,                
                        pageRowCount : 10,                
                        editable : false,                
                        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
                        enableSorting : true,
                        softRemoveRowMode:false,
                        reverseRowNum : true
                        };

    $(document).ready(function(){
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid(columnLayout);
        //copyAUIGrid(columnLayout);
        AUIGrid.setGridData(myGridID, []);
        doDefCombo(comboData, '' ,'cmbStatus', 'M', 'f_multiCombo');
    });

    function f_removeclass(){
        var lisize = $("#subDiv > ul > li").size();
        for (var i = 0 ; i < lisize ; i++){
            $("#subDiv > ul > li").eq(i).find("a").removeAttr("class");
        }
        
        var r = $("#subDiv > .tap_area").size();
        for(var i = 0 ; i < r ; i++){
            $("#subDiv > .tap_area").eq(i).hide();
        }
        
    }

    $(function(){
    	$("#stockIns").click(function(){
    		$("#editWindow").show();
    		doGetCombo('/common/selectCodeList.do', '42', '','insUom', 'S'); //청구처 리스트 조회
    		doGetCombo('/common/selectCodeList.do', '11', '', 'insCate', 'S', '');
    	});
        $("#stock_info").click(function(){
            if($("#stock_info_div").css("display") == "none"){
                f_removeclass();
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    $("#stkId").val(selectedItems[i].item.stkid);
                    f_view("/stock/StockInfo.do?stkid="+selectedItems[i].item.stkid , "S");
                }
                $("#stock_info_div").show();
            }else{
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    $("#stkId").val(selectedItems[i].item.stkid);
                    f_view("/stock/StockInfo.do?stkid="+selectedItems[i].item.stkid , "S");
                }
            }
            $(this).find("a").attr("class","on");
            $("#stock_info_edit").text("EDIT");
        });
        
        $("#price_info").click(function(){
        	
            if($("#price_info_div").css("display") == "none"){
                f_removeclass();
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/PriceInfo.do?stkid="+selectedItems[i].item.stkid+"&typeid="+selectedItems[i].item.stktypeid, "P");
                }
                $("#price_info_div").show();
            }else{
                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/PriceInfo.do?stkid="+selectedItems[i].item.stkid+"&typeid="+selectedItems[i].item.stktypeid, "P");
                }
            }
            $(this).find("a").attr("class","on");
            $("#price_info_edit").text("EDIT");
        });
        
        $("#filter_info").click(function(){
            f_removeclass();
            $("#filter_info_div").show();
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for(i=0; i<selectedItems.length; i++) {
               //f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkid+"&grid=filter", "F");
               f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkcode+"&grid=filter", "F");
            }
            $(this).find("a").attr("class","on");
        });
        
        $("#spare_info").click(function(){
            f_removeclass();
            $("#spare_info_div").show();
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for(i=0; i<selectedItems.length; i++) {
                //f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkid+"&grid=spare", "R");
                f_view("/stock/FilterInfo.do?stkid="+selectedItems[i].item.stkcode+"&grid=spare", "R");
            }                
            $(this).find("a").attr("class","on");
        });
        
        $("#service_info").click(function(){
            f_removeclass();
            $("#service_info_div").show();
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for(i=0; i<selectedItems.length; i++) {
                f_view("/stock/ServiceInfo.do?stkid="+selectedItems[i].item.stkid, "V");
            }
            $(this).find("a").attr("class","on");
            $("#service_info_edit").text("EDIT");
        });
        
        $("#service_point").click(function(){
            f_removeclass();
            $("#service_point_div").show();
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            var item = selectedItems[0].item;
            console.log(item);
            $("#as").text(item.c6);
            $("#osas").text(item.c7);
            $("#hs").text(item.c8);
            $("#oshs").text(item.c9);
            $("#install").text(item.c10);
            $("#osinstall").text(item.c11);
            $(this).find("a").attr("class","on");
        });
        
        $("#stock_image").click(function(){

            if($("#stock_img_td").css("display") == "none"){
                f_removeclass();
                $("#stock_img_td").show();

                var selectedItems = AUIGrid.getSelectedItems(myGridID);
                for(i=0; i<selectedItems.length; i++) {
                    f_view("/stock/selectStockImgList.do?stkid="+selectedItems[i].item.stkid, "I");
                }

            }else{

            }
            $(this).find("a").attr("class","on");
        });

        $("#stock_commisssion").click(function(){
            var type;
            f_removeclass();
            $("#stock_commisssion_div").show();
            var selectedItems = AUIGrid.getSelectedIndex(myGridID);
            var stkid = AUIGrid.getCellValue(myGridID, selectedItems[0], "stkid")  
            var stusid = AUIGrid.getCellValue(myGridID, selectedItems[0], "statuscodeid")              
            if(stusid ==1){
                $("#stock_comm_edit").show();
                type="CE";
            }else{
                $("#stock_comm_edit").hide();
                type="C";
            }
            f_view("/stock/StockCommisionSetting.do?stkid="+stkid, type);
            $(this).find("a").attr("class","on");

        });

        $("#search").click(function(){
            $('#subDiv').hide();
            getSampleListAjax();
        });

        $("#clear").click(function(){
            doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //청구처 리스트 조회
            doGetCombo('/common/selectCodeList.do', '15', '','cmbType', 'M' , 'f_multiCombo'); //청구처 리스트 조회
            doDefCombo(comboData, '','cmbStatus', 'M', 'f_multiCombo');
            $("#stkCd").val('');
            $("#stkNm").val('');
        });

        $("#stock_info_edit").click(function(){

            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for(i=0; i<selectedItems.length; i++) {
                if ($("#stock_info_edit").text() == "EDIT"){
                   // if (selectedItems[i].item.statuscodeid == '1'){
                        f_view("/stock/StockInfo.do?stkid="+selectedItems[i].item.stkid+"&mode=edit", "ES");
                  //  }else{
                  //      alert(selectedItems[i].item.name + ' is a state that can not be changed.');
                  //  }
                }else if ($("#stock_info_edit").text() == "SAVE"){
                    f_info_save("/stock/modifyStockInfo.do" , selectedItems[i].item.stkid , "stockInfo" ,"stock_info");
                    //$("#stock_info_edit").text("EDIT");
                }
            }
        });

        $("#price_info_edit").click(function(){
            
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for(i=0; i<selectedItems.length; i++) {
                if ($("#price_info_edit").text() == "EDIT"){
                  //  if (selectedItems[i].item.statuscodeid == '1'){
                        f_view("/stock/PriceInfo.do?stkid="+selectedItems[i].item.stkid+"&typeid="+selectedItems[i].item.stktypeid, "EP");
                 //   }else{
                  //      alert(selectedItems[i].item.name + ' is a state that can not be changed.');
                  //  }
                }else if ($("#price_info_edit").text() == "SAVE"){
                    f_info_save("/stock/modifyPriceInfo.do" , selectedItems[i].item.stkid , "priceForm" ,"price_info");
                    //$("#stock_info_edit").text("EDIT");
                }
            }
        });
        
        //
        $("#service_info_edit").click(function(){
            var selectedItems = AUIGrid.getSelectedItems(myGridID);

            if($("#service_info_edit").text() == "EDIT"){ 
                colShowHide(serviceGrid,"",true);
                $("#service_info_edit").text("Add Service Charge") ;
            }else if ($("#service_info_edit").text() == "Add Service Charge"){
                addRowSvr();
                fn_srvMembershipList();
            }else if ($("#service_info_edit").text() == "SAVE"){
                f_info_save("/stock/modifyServiceInfo.do" , selectedItems[0].item.stkid ,GridCommon.getEditData(serviceGrid),"service_info");  
            }

        });
        $("#service_point_edit").click(function(){
        	
        	var selectedItems = AUIGrid.getSelectedItems(myGridID);
            var item = selectedItems[0].item;
            
        	if($("#service_point_edit").text() == "EDIT"){
        		$("#as").html        ("<input type='text' class='w100p' id='ias'        name='ias'        value='"+item.c6 +"'>");
                $("#osas").html      ("<input type='text' class='w100p' id='iosas'      name='iosas'      value='"+item.c7 +"'>");
                $("#hs").html        ("<input type='text' class='w100p' id='ihs'        name='ihs'        value='"+item.c8 +"'>");
                $("#oshs").html      ("<input type='text' class='w100p' id='ioshs'      name='ioshs'      value='"+item.c9 +"'>");
                $("#install").html   ("<input type='text' class='w100p' id='iinstall'   name='iinstall'   value='"+item.c10+"'>");
                $("#osinstall").html ("<input type='text' class='w100p' id='iosinstall' name='iosinstall' value='"+item.c11+"'>");
                $("#service_point_edit").text("SAVE");
        	}else if ($("#service_point_edit").text() == "SAVE"){
        		f_info_save("/stock/modifyServicePoint.do" , item.stkid ,"servicepoint","service_point");
        	}
        });
        
        $("#stock_comm_edit").click(function(){
            var selectedItems = AUIGrid.getSelectedIndex(myGridID);
            var stkid = AUIGrid.getCellValue(myGridID, selectedItems[0], "stkid")  
            f_info_save("/stock/StockCommisionUpdate.do" , stkid , "commForm" ,"");

        });

        $(".numberAmt").keyup(function(e) {
            //regex = /^[0-9]+(\.[0-9]+)?$/g;
            regex = /[^.0-9]/gi;

            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
        });

        $("#stkCd").keypress(function(event) {
            if (event.which == '13') {
                $("#svalue").val($("#stkCd").val());
                $("#sUrl").val("/logistics/material/materialcdsearch.do");
                Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
            }
        });
        
        
        $('#txtNormalPrice').keypress(function() {
            if (event.which == '13') {
                var findStr=".";
                var sublen;
                var prices = $("#dNormalPrice").val();
                var priceslen=prices.length;
                //alert("????"+prices.indexOf(findStr));
                if (prices.indexOf(findStr) > 0) {  
                  sublen= prices.indexOf('.');
                  sublen=sublen+1;
                  var sums = priceslen - sublen;
                //  alert("sums :  "+sums);
                  if(sums == 0 ){
                      $("#dNormalPrice").val(prices+"00");  
                  }else if(sums == 1 ){
                      $("#dNormalPrice").val(prices+"0");  
                  }else if(sums == 2){
                        
                  }else{
                      Common.alert("Please enter only the second decimal place.");
                      $("#dNormalPrice").val("");
                  }
                 
                  }else if(prices.indexOf(findStr) == 0){
                      Common.alert('You can not enter decimal numbers first.');
                      $("#dNormalPrice").val("");
                  }else{
                    //  alert('Not Found!!');
                      $("#dNormalPrice").val($.number(prices,2));  
                  } 
    
            }
        });
        
        
        $('#txtCost').keypress(function() {
            if (event.which == '13') {
                var findStr=".";
                var sublen;
                var prices = $("#dCost").val();
                var priceslen=prices.length;
                //alert("????"+prices.indexOf(findStr));
                if (prices.indexOf(findStr) > 0) {  
                  sublen= prices.indexOf('.');
                  sublen=sublen+1;
                  var sums = priceslen - sublen;
                //  alert("sums :  "+sums);
                  if(sums == 0 ){
                      $("#dCost").val(prices+"00");  
                  }else if(sums == 1 ){
                      $("#dCost").val(prices+"0");  
                  }else if(sums == 2){
                        
                  }else{
                      Common.alert("Please enter only the second decimal place.");
                      $("#dCost").val("");
                  }
                 
                  }else if(prices.indexOf(findStr) == 0){
                      Common.alert('You can not enter decimal numbers first.');
                      $("#dCost").val("");
                  }else{
                    //  alert('Not Found!!');
                      $("#dCost").val($.number(prices,2));  
                  } 
    
            }
        });
    });
    
    function f_info_save(url, key, v, f) {
        var fdata;
        if (f == "service_info" || f == "filter_info" || f == "spare_info") {
            fdata = v;
        } else {
            fdata = $("#" + v).serializeJSON();
        }
        
        console.log(" ::: " + fdata);
        var keys = Object.keys(fdata);
        
        if (v == "stockInfo") {
            if ($("#cbSirim").is(":checked") == true) {
                $.extend(fdata, {
                    'cbSirim' : '1'
                });
            } else {
                $.extend(fdata, {
                    'cbSirim' : '0'
                });
            }
            if ($("#cbNCV").is(":checked") == true) {
                $.extend(fdata, {
                    'cbNCV' : '1'
                });
            } else {
                $.extend(fdata, {
                    'cbNCV' : '0'
                });
            }
        }
        $.extend(fdata, {
            'stockId' : key
        });
        $.extend(fdata, {
            'revalue' : f
        });

        Common.ajax("POST", url, fdata, function(data) {
            //alert("msg "+data.msg);
            Common.alert(data.message);
            if (v == "stockInfo") {
                $("#stock_info_edit").text("EDIT");
            } else if (v == "priceForm") {
                $("#price_info_edit").text("EDIT");
            } else if(f == "filter_info"){
                $("#filter_info_edit").text("EDIT");
                colShowHide(filterGrid,"",false);
                $("#filter_info").trigger("click");
            } else if(f == "spare_info"){
                $("#spare_info_edit").text("EDIT");
                colShowHide(spareGrid,"",false);
                $("#spare_info").trigger("click");
            } else if(f == "service_info"){
                $("#service_info_edit").text("EDIT");
                colShowHide(serviceGrid,"",false);
                $("#service_info").trigger("click");
            }else if (v == "servicepoint") {
                $("#service_point_edit").text("EDIT");
            }
            getMainListAjax(data);
        });
    }

    function getMainListAjax(_da) {

        var param = $('#searchForm').serialize();
        var selcell = 0;
        var selectedItems = AUIGrid.getSelectedItems(myGridID);
        for (i = 0; i < selectedItems.length; i++) {
            selcell = selectedItems[i].rowIndex;
        }
        
        console.log(_da);

        $.ajax({
            type : "GET",
            url : "/stock/StockList.do?" + param,
            //url : "/stock/StockList.do",
            //data : param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                var gridData = data;
                AUIGrid.setGridData(myGridID, gridData.data);
                AUIGrid.setSelectionByIndex(myGridID, selcell, 3);

                $("#" + _da.revalue).click();
            },
            error : function(jqXHR, textStatus, errorThrown) {
                alert("실패하였습니다.");
            },
            complete : function() {
            }
        });
    }

    // AUIGrid 를 생성합니다.
    function createAUIGrid(columnLayout) {

        // 실제로 #grid_wrap 에 그리드 생성
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

        //
        AUIGrid.bind(myGridID, "cellClick",
                function(event) {
                    f_removeclass();
                    var selectedItems = event.selectedItems;
                    f_view("/stock/StockInfo.do?stkid="
                            + AUIGrid.getCellValue(myGridID, event.rowIndex,
                                    "stkid"), "S");
                    $("#subDiv").show();
                    if (AUIGrid.getCellValue(myGridID, event.rowIndex,
                            "stktypeid") == "61") {
                        $("#filter_info").show();
                        $("#spare_info").show();
                        $("#service_info").hide();
                        $("#stock_commisssion").show();
                    } else {
                        $("#service_info").show();
                        $("#filter_info").hide();
                        $("#spare_info").hide();
                        $("#stock_commisssion").hide();
                    }
                    $("#stock_info_div").show();
                    $("#price_info_div").hide();
                    $("#filter_info_div").hide();
                    $("#service_info_div").hide();
                    $("#service_point_div").hide();
                    $("#stock_img_td").hide();
                    $("#stock_commisssion_div").hide();
                    $("#imgShow").html("");
                    $("#stock_info").find("a").attr("class", "on");
                    $("#stock_info_edit").text("EDIT");
                    /*if (){
                        
                    }*/
                });
    }


    // AUIGrid 를 생성합니다.
    function filterAUIGrid(filtercolumn) {
        filterGrid = AUIGrid.create("#filter_grid", filtercolumn, subgridpros);
    }

    function spareAUIGrid(sparecolumn) {
        spareGrid = AUIGrid.create("#spare_grid", sparecolumn, subgridpros);
    }

    function serviceAUIGrid(servicecolumn) {
        serviceGrid = AUIGrid.create("#service_grid", servicecolumn,subgridpros);
    }

    function imgAUIGrid(stockimgcolumn) {
        imgGrid = AUIGrid.create("#stock_img_div", stockimgcolumn, subgridpros);
    }
    function priceHistoryAUIGrid(pricehiscolumn) {
        priceHistoryGrid = AUIGrid.create("#priceHistory_div", pricehiscolumn, subgridpros2);
    }

    function getSampleListAjax() {

        //$.blockUI({ message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' />" }); 
        //f_showModal();

     var param = $('#searchForm').serialize();
        console.log(param);
        Common.ajax("GET" , "/stock/StockList.do" , param , function(data){
        	var gridData = data;
        	AUIGrid.setGridData(myGridID, gridData.data);
        });
        
//         $.ajax({
//             type : "POST",
//             url : "/stock/StockList.do?" + param,
//             //url : "/stock/StockList.do",
//             //data : param,
//             dataType : "json",
//             contentType : "application/json;charset=UTF-8",
//             success : function(data) {
//                 var gridData = data;

//                 AUIGrid.setGridData(myGridID, gridData.data);
//             },
//             error : function(jqXHR, textStatus, errorThrown) {
//                 alert("실패하였습니다.");
//             },
//             complete : function() {
//                 hideModal();
//                 //$.unblockUI();
//             }
//         });
    }

    
    function f_view(url, v) {
        f_clearForm();
        $.ajax({
            type : "POST",
            url : url,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(_data) {
                //var data = _data.data;
                f_info(_data, v);
            },
            error : function(jqXHR, textStatus, errorThrown) {
                alert("실패하였습니다.");
            }
        });
    }

    function f_info(_data, v) {
        var data = _data.data;
        var data2 = _data.data2;
        
        if (v == 'S') {
            $("#txtStockType").empty();
            $("#txtStockCode").empty();
            $("#txtUOM").empty();

            $("#txtStockName").empty();
            $("#txtCategory").empty();

            $("#txtNetWeight").empty();
            $("#txtMeasurement").empty();

            $("#txtStockType").text(data[0].typenm);
            $("#txtStatus").text(data[0].statusname);
            $("#txtStockCode").text(data[0].stockcode);
            $("#txtUOM").text(data[0].uomname);
            $("#txtStockName").text(data[0].stockname);
            $("#txtCategory").text(data[0].categotynm);

            $("#txtNetWeight").text(data[0].netweight);
            $("#txtGrossWeight").text(data[0].grossweight);
            $("#txtMeasurement").text(data[0].mcbm);

            if (data[0].isncv == 1) {
                $("#cbNCV").prop("checked", true);
            }
            if (data[0].issirim == 1) {
                $("#cbSirim").prop("checked", true);
            }
            $("#cbNCV").prop("disabled", true);
            $("#cbSirim").prop("disabled", true);

            $("#typeid").val(data[0].typeid);
        } else if (v == 'ES') {
        	
        	
            $("#cbNCV").prop("disabled", false);
            $("#cbSirim").prop("disabled", false);

            $("#txtStockType").text(data[0].typenm);
            $("#txtStockType")
                    .append(
                            "<input type='hidden' name='stock_type' id='stock_type' value=''/>");
            $("#stock_type").val(data[0].typeid);
//             $("#txtStatus").text(data[0].statusname);
//             $("#txtStatus").html("<select id='statusselect' name='statusselect' class='w100'></select>");
//             doDefCombo(comboData,  data[0].statusname,'statusselect', 'S'); 
            $("#txtStatus").text(data[0].statusname);
            $("#txtStatus").html("<select id='statusselect' name='statusselect' class='w100'></select>");
            doDefCombo(comboData,  data[0].statusid,'statusselect', 'S'); 
            $("#txtStockCode")
                    .html(
                            "<input type='text' name='stock_code' id='stock_code' class='w100p' value='' disabled=true/>");
            $("#stock_code").val(data[0].stockcode);
            $("#txtUOM").html(
                    "<select id='stock_uom' name='stock_uom'></select>");
            doGetCombo('/common/selectCodeList.do', '42', data[0].uomname,
                    'stock_uom', 'S'); //청구처 리스트 조회
            $("#txtStockName")
                    .html(
                            "<input type='text' name='stock_name' id='stock_name' class='w100' value=''/>");
            $("#stock_name").val(data[0].stockname);
            $("#txtCategory")
                    .html(
                            "<select id='stock_category' name='stock_category' class='w100p'></select>");
            doGetCombo('/common/selectCodeList.do', '11', data[0].categotynm,
                    'stock_category', 'S'); //청구처 리스트 조회
            $("#txtNetWeight")
                    .html(
                            "<input type='text' name='netweight' id='netweight' class='w100p' value=''/>");
            $("#netweight").val(data[0].netweight);
            $("#txtGrossWeight")
                    .html(
                            "<input type='text' name='grossweight' class='w100p' id='grossweight' value=''/>");
            $("#grossweight").val(data[0].grossweight);
            $("#txtMeasurement")
                    .html(
                            "<input type='text' name='measurement' class='w100p' id='measurement' value=''/>");
            $("#measurement").val(data[0].mcbm);

            if (data[0].isncv == 1) {
                $("#cbNCV").prop("checked", true);
            }
            if (data[0].issirim == 1) {
                $("#cbSirim").prop("checked", true);
            }
            $("#typeid").val(data[0].typeid);
            $("#stock_info_edit").text("SAVE");
        } else if (v == 'P') {
            $("#txtCost").empty();
            $("#txtNormalPrice").empty();
            $("#txtPV").empty();
            $("#txtMonthlyRental").empty();
            $("#txtRentalDeposit").empty();
            $("#txtPenaltyCharge").empty();
            $("#txtTradeInPV").empty();

            $("#txtCost").text(data[0].pricecost);
            $("#txtNormalPrice").text(data[0].amt);
            $("#txtPV").text(data[0].pricepv);
            $("#txtMonthlyRental").text(data[0].mrental);
            $("#txtRentalDeposit").text(data[0].pricerpf);
            $("#txtPenaltyCharge").text(data[0].penalty);
            $("#txtTradeInPV").text(data[0].tradeinpv);
            
                destory(priceHistoryGrid);
                priceHistoryAUIGrid(pricehiscolumn);
                AUIGrid.setGridData(priceHistoryGrid, data2); 
        } else if (v == 'EP') {
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            var typeid = "";
            for (i = 0; i < selectedItems.length; i++) {
                typeid = selectedItems[i].item.stktypeid;
            }
            $("#priceTypeid").val(typeid);
            if (typeid == '61') {
                $("#txtPenaltyCharge")
                        .html(
                                "<input type='text' name='dPenaltyCharge' id='dPenaltyCharge' disabled=true value='' class='w100p numberAmt'/>"); //PriceCharges
                $("#dPenaltyCharge").val(data[0].penalty);
                $("#txtPV")
                        .html(
                                "<input type='text' name='dPV' id='dPV' value='' class='w100p numberAmt'/>"); //PricePV
                $("#dPV").val(data[0].pricepv);
                $("#txtMonthlyRental")
                        .html(
                                "<input type='text' name='dMonthlyRental' id='dMonthlyRental' value='' class='w100p numberAmt'/>"); //amt
                $("#dMonthlyRental").val(data[0].mrental);
                $("#txtRentalDeposit")
                        .html(
                                "<input type='text' name='dRentalDeposit' id='dRentalDeposit' value='' class='w100p numberAmt'/>"); //PriceRPF
                $("#dRentalDeposit").val(data[0].pricerpf);
                $("#txtTradeInPV")
                        .html(
                                "<input type='text' name='dTradeInPV' id='dTradeInPV' value='' class='w100p numberAmt'/>"); //TradeInPV
                $("#dTradeInPV").val(data[0].tradeinpv);
            } else {
                $("#txtPenaltyCharge")
                        .html(
                                "<input type='text' name='dPenaltyCharge' id='dPenaltyCharge' value='' class='w100p numberAmt'/>"); //PriceCharges
                $("#dPenaltyCharge").val(data[0].penalty);
                $("#txtPV")
                        .html(
                                "<input type='text' name='dPV' id='dPV' disabled=true value='' class='w100p numberAmt'/>"); //PricePV
                $("#dPV").val(data[0].pricepv);
                $("#txtMonthlyRental")
                        .html(
                                "<input type='text' name='dMonthlyRental' id='dMonthlyRental' disabled=true value='' class='w100p numberAmt'/>"); //amt
                $("#dMonthlyRental").val(data[0].mrental);
                $("#txtRentalDeposit")
                        .html(
                                "<input type='text' name='dRentalDeposit' id='dRentalDeposit' disabled=true value='' class='w100p numberAmt'/>"); //PriceRPF
                $("#dRentalDeposit").val(data[0].pricerpf);
                $("#txtTradeInPV")
                        .html(
                                "<input type='text' name='dTradeInPV' id='dTradeInPV' disabled=true value='' class='w100p numberAmt'/>"); //TradeInPV
                $("#dTradeInPV").val(data[0].tradeinpv);
            }
            $("#txtCost")
                    .html(
                            "<input type='text' name='dCost' id='dCost' value='' class='w100p numberAmt'/>"); //PriceCosting
            $("#dCost").val(data[0].pricecost);
            $("#txtNormalPrice")
                    .html(
                            "<input type='text' name='dNormalPrice' id='dNormalPrice' value='' class='w100p numberAmt'/>"); // amt
            $("#dNormalPrice").val(data[0].amt);

            $("#price_info_edit").text("SAVE");

            destory(priceHistoryGrid);
            priceHistoryAUIGrid(pricehiscolumn);
            AUIGrid.setGridData(priceHistoryGrid, data2);  
            
        } else if (v == 'F') {
            destory(filterGrid);
            filterAUIGrid(filtercolumn)
            AUIGrid.setGridData(filterGrid, data);
            colShowHide(filterGrid,"",false);

        } else if (v == 'R') {
            destory(spareGrid);
            spareAUIGrid(sparecolumn);
            AUIGrid.setGridData(spareGrid, data);
            colShowHide(spareGrid,"",false);

        } else if (v == 'V') {
            destory(serviceGrid);
            serviceAUIGrid(servicecolumn);
            AUIGrid.setGridData(serviceGrid, data);
            colShowHide(serviceGrid,"",false);

        } else if (v == 'I') {
            destory(imgGrid);
            imgAUIGrid(stockimgcolumn);
            AUIGrid.setGridData(imgGrid, data);
            //colShowHide(imgGrid,"",false);

      } else if (v == 'C') {
          $("#txtStckCd").text(data[0].stkCode);
          $("#txtStckCtgry").text(data[0].codeName);
          $("#txtStckNm").text(data[0].stkDesc);
          $("#txtRate_as").text(decimalSetting(data[0].c6));
          $("#txtOutRate_as").text(decimalSetting(data[0].c7));
          $("#txtRate_bs").text(decimalSetting(data[0].c8));
          $("#txtOutRate_bs").text(decimalSetting(data[0].c9));
          $("#txtRate_install").text(decimalSetting(data[0].c10));
          $("#txtOutRate_install").text(decimalSetting(data[0].c11));
        
      } else if (v == 'CE') {
    	    //TODO 숫자 포맷 및 입력 제한 해야함
          $("#txtStckCd").text(data[0].stkCode);
          $("#txtRate_as").append("<input type='hidden' name='stckcd' id='stckcd' value=''/>");
          $("#stckcd").val(data[0].stkCode);
          $("#txtStckCtgry").text(data[0].codeName);
          $("#txtStckNm").text(data[0].stkDesc);        
          $("#txtRate_as").html("<input type='text' name='rate_as' id='rate_as' value='' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' onclick='setRate(event)'/>");
          $("#txtOutRate_as").html("<input type='text' name='outrate_as' id='outrate_as' value='' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  onclick='setRate(event)'/>");
          $("#txtRate_bs").html("<input type='text' name='rate_bs' id='rate_bs' value='' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  onclick='setRate(event)'/>");
          $("#txtOutRate_bs").html("<input type='text' name='outrate_bs' id='outrate_bs' value='' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  onclick='setRate(event)'/>");
          $("#txtRate_install").html("<input type='text' name='rate_install' id='rate_install' value='' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  onclick='setRate(event)'/>");
          $("#txtOutRate_install").html("<input type='text' name='outrate_install' id='outrate_install' value='' onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  onclick='setRate(event)'/>");
          $("#rate_as").val(decimalSetting(data[0].c6));
          $("#outrate_as").val(decimalSetting(data[0].c7));
          $("#rate_bs").val(decimalSetting(data[0].c8));
          $("#outrate_bs").val(decimalSetting(data[0].c9));
          $("#rate_install").val(decimalSetting(data[0].c10));
          $("#outrate_install").val(decimalSetting(data[0].c11));
          
      }
          
          
    }

    function decimalSetting(str){
        var num=Number(str).toFixed(2);
        return num;
    }
    
 
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
    //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
    doGetCombo('/common/selectCodeList.do', '11', '', 'cmbCategory', 'M', 'f_multiCombo');
    doGetCombo('/common/selectCodeList.do', '15', '', 'cmbType', 'M','f_multiCombo');
    //doDefCombo(comboData, '' ,'cmbStatus', 'M', 'f_multiCombo');

    function f_multiCombo() {
        $(function() {
            $('#cmbCategory').change(function() {

            }).multipleSelect({
                selectAll : true, // 전체선택 
                width : '80%'
            });
            $('#cmbType').change(function() {

            }).multipleSelect({
                selectAll : true,
                width : '80%'
            });
            $('#cmbStatus').change(function() {

            }).multipleSelect({
                selectAll : true,
                width : '80%'
            });
        });
    }

    function f_clearForm() {
        $("#typeid").val("");
        $("#txtStockType").text();
        $("#txtStatus").text();
        $("#txtStockCode").text();
        $("#txtUOM").text();
        $("#txtStockName").text();
        $("#txtCategory").text();
        $("#txtNetWeight").text();
        $("#txtGrossWeight").text();
        $("#txtMeasurement").text();
        $("#cbNCV").prop("checked", false);
        $("#cbSirim").prop("checked", false);
        $("#txtCost").text();
        $("#txtNormalPrice").text();
        $("#txtPV").text();
        $("#txtMonthlyRental").text();
        $("#txtRentalDeposit").text();
        $("#txtPenaltyCharge").text();
        $("#txtTradeInPV").text();
    }

    function f_isNumeric(val) {
        var num = $(val).val();

        // 좌우 trim(공백제거)을 해준다.
        num = String(num).replace(/^\s+|\s+$/g, "");
        var regex = /^[0-9]+(\.[0-9]+)?$/g;

        if (regex.test(num)) {
            num = num.replace(/,/g, "").toFixed(2);
            return isNaN(num) ? false : true;
        } else {
            return false;
        }
    }

    
    function onlyNumber(event){
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
            if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 110 || keyID == 190){ 
                return;
        }else{
                return false;
        }
    }
    function removeChar(event) {
        event = event || window.event;
        var tmp=event.target.value;
        var keyID = (event.which) ? event.which : event.keyCode;
        if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 190) {
            return;
        }else{
              event.target.value = event.target.value.replace(/[^.0-9]/g, "");
        }     //event.target.value =  event.target.value.replace(/[^0-9]([^0-9]|[\.]{1})[^0-9]{1,2}/g, "");
    }
    
    function setRate(event){
        event = event || window.event;
        var tmp=event.target.value;
        if(tmp == 0.00){
           event.target.value="";
       }
        event.target.focus;
    }
    
    function removeRow(rowIndex, gridNm, num) {

        AUIGrid.removeRow(gridNm, rowIndex);
        AUIGrid.removeSoftRows(gridNm);
        
          if (num == 1) {
              $("#filter_info_edit").text("SAVE");
        } else if (num == 2) {
              $("#spare_info_edit").text("SAVE");
        } else if (num == 3){
              $("#service_info_edit").text("SAVE");
        }
    }

    function addRowSvr() {
        var item = new Object();
        AUIGrid.addRow(serviceGrid, item, "last");
        $("#service_info_edit").text("SAVE");
    }
    function addRowFileter() {
        var item = new Object();
        item.stockid = $("#filtercdPop").val();
        item.stockname = $("#filtercdPop option:selected").text();
        //item.stock     =   $("#").val();
        item.typeid = $("#filtertypePop").val();
        item.typenm = $("#filtertypePop option:selected").text();
        item.period = $("#lifeperiodPop").val();
        item.qty = $("#quantityPop").val();
        AUIGrid.addRow(filterGrid, item, "last");
        $("#filter_info_edit").text("SAVE");
         $("#regFilterWindow").hide(); 
    }
    
     function cancelRowFileter(){
         $("#regFilterWindow").hide();  
      }
    
    function addRowSparePart(){
        var item = new Object();
        item.stockid = $("#sparecdPop").val();
        item.stockname = $("#sparecdPop option:selected").text();
        //item.stock     =   $("#").val();
       // item.typeid = $("#filtertypePop").val();
       // item.typenm = $("#filtertypePop option:selected").text();
       // item.period = $("#lifeperiodPop").val();
        item.qty = $("#quantityPop_sp").val();
        AUIGrid.addRow(spareGrid, item, "last");
        $("#spare_info_edit").text("SAVE");
        $("#regSpareWindow").hide();          
    }
    
       function cancelRowSparePart(){
           $("#regSpareWindow").hide();  
        }
    
    
    function fn_srvMembershipList() {
        Common.ajaxSync("GET", "/stock/srvMembershipList ", "",
                function(result) {
                    srvMembershipList = new Array();
                    for (var i = 0; i < result.length; i++) {
                        var list = new Object();
                        list.pacid = result[i].pacid;
                        list.memcd = result[i].memcd;
                        list.cdname = result[i].cdname;
                        srvMembershipList.push(list);
                    }
                });
    }
    
    function destory(gridNm){
        AUIGrid.destroy(gridNm);
        $("#service_info_edit").text( "EDIT");
        $("#filter_info_edit").text("EDIT");
        $("#spare_info_edit").text("EDIT");
        popClear();
    }
    function popClear(){
        $("#filterForm")[0].reset();
        $("#filtercdPop").attr("disabled",true);
        $("#spareForm")[0].reset();
        $("#sparecdPop").attr("disabled",true);
        
    }
    
    function colShowHide(gridNm,fied,checked){
          if(checked) {
                AUIGrid.showColumnByDataField(gridNm, fied);
            } else {
                AUIGrid.hideColumnByDataField(gridNm, fied);
            }
    }
    
    function fn_nonvalueItem(val){
    	if (val == '2'){
    		$("#editWindow").hide();
    	}else{
    		if (nonvalueValidationChk()){
    			fdata = $("#insForm").serializeJSON();
    			
    			if ($("#insNCV").is(":checked") == true) {
   	                $.extend(fdata, {
   	                    'insNCV' : '1'
   	                });
   	            } else {
   	                $.extend(fdata, {
   	                    'insNCV' : '0'
   	                });
   	            }
   	            if ($("#insSirim").is(":checked") == true) {
   	                $.extend(fdata, {
   	                    'insSirim' : '1'
   	                });
   	            } else {
   	                $.extend(fdata, {
   	                    'insSirim' : '0'
   	                });
   	            }
	   	        if ($("#insas").is(":checked") == true) {
	                $.extend(fdata, {
	                    'insas' : '1'
	                });
	            } else {
	                $.extend(fdata, {
	                    'insas' : '0'
	                });
	            }
	            var url = "/stock/nonvalueStockIns.do"
	            
    	        Common.ajax("POST", url, fdata, function(data) {
    	        	console.log(data);
    	        	if (data.data != '0'){
    	        		Common.alert("Code already registered.");
                        return false;
    	        	}else{
    	        		getSampleListAjax();
    	        		$("#editWindow").hide();
    	        	}
    	        });
    		}else{
    			return false;
    		}
    	}
    }
    function nonvalueValidationChk(){
    	console.log($("#insForm").serializeJSON());
    	/*insCate    	:    	"55"
    	insNCV    	:    	"on"
    	insSirim    	:    	"on"
    	insStockCode    	:    	"safas"
    	insUom    	:    	"71"
    	insas    	:    	"on"
    	insnp    	:    	"200"
    	istockType    	:    	"2687"
    	mwarenm    	:    	"safdasf"
    	oldStockNo    	:    	"safdasfd"*/
    	if ($("#insStockCode").val() == ""){
    		return false;
    	}else{
    		var stype = $("#insStockCode").val();
    		console.log(stype.substr(0,1));
    		console.log(stype.substr(1));
    		if (stype.substr(0,1) != 'M'){
    			Common.alert("The Stock Code can only be generated from M500000 to M599999.");
    			return false;
    		}else {
    			if (stype.substr(1) < "500000" || stype.substr(1) > "599999"){
    				Common.alert("The Stock Code can only be generated from M500000 to M599999.");
                    return false;
    			}
    		}
    	}
    	if ($("#insUom").val() == ""){
    		Common.alert("UOM is a required value.");
            return false;
        }
    	if ($("#istocknm").val() == ""){
    		Common.alert("Stock Name is a required value.");
            return false;
        }
    	if ($("#insCate").val() == ""){
    		Common.alert("Stock Category is a required value.");
            return false;
        }
    	return true;
    }
    
    function fn_itempopList(data){
    	console.log(data);
        $("#stkCd").val(data[0].item.itemcode);
        $("#stkNm").val(data[0].item.itemname);
    }
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv">
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
        <li>Logistics</li>
        <li>Material Code</li>
    </ul>
    
    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Stocks</h2>
        <ul class="right_opt">
          <%//@ include file="/WEB-INF/jsp/common/contentButton.jsp" %>
            <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li> 
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl"   name="sUrl"  />    
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Category</th>
                    <td>
                        <select class="w100p" id="cmbCategory" name="cmbCategory"></select>
                    </td>
                    <th scope="row">Type</th>
                    <td>
                        <select class="w100p" id="cmbType" name="cmbType"></select>
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="cmbStatus" name="cmbStatus"></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td>
                        <input type=text name="stkCd" id="stkCd" class="w100p" value=""/>
                    </td>
                    <th scope="row">Material Name</th>
                    <td colspan='3'>
                        <input type=text name="stkNm" id="stkNm" class="w100p" value=""/>
                    </td>                
                </tr>
            </tbody>
        </table><!-- table end -->

    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
<!--             <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL UP</a></p></li> -->
<!--             <li><p class="btn_grid"><a href="#"><span class="search"></span>EXCEL DW</a></p></li> -->
<!--             <li><p class="btn_grid"><a href="#"><span class="search"></span>DEL</a></p></li> -->
            <li><p class="btn_grid"><a id="stockIns">INS</a></p></li>
<!--             <li><p class="btn_grid"><a href="javascript:f_tabHide()">Add</p></li> -->
        </ul>

        <div id="grid_wrap" class="mt10" style="height:350px"></div>

        <section id="subDiv" style="display:none;" class="tap_wrap"><!-- tap_wrap start -->
        
            <ul class="tap_type1">
                <li id="stock_info"><a href="#"> Stock info </a></li>
                <li id="price_info"><a href="#"> Price & Value Information</a></li>
                <li id="filter_info"><a href="#"> Filter Info</a></li>
                <li id="spare_info"><a href="#"> Spare Part Info</a></li>
                <li id="service_info"><a href="#">Service Charge Info</a></li>
                <li id="service_point"><a href="#">Service Point</a></li>
                <li id="stock_image"><a href="#">Stock Image</a></li>
                <li id="stock_commisssion"><a href="#">Stock Commission Setting</a></li>
            </ul>
            <article class="tap_area" id="stock_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Stock Information</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="stock_info_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <form id="stockInfo" name="stockInfo" method="post">
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">Material Type</th>
                        <td ID="txtStockType"></td>
                        <th scope="row">Status</th>
                        <td ID="txtStatus"></td>
                        <td colspan="2">
                            <label><input type="checkbox" id="cbSirim"/><span>Sirim Certificate</span></label>
                            <label><input type="checkbox" id="cbNCV" /><span>NCV</span></label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Material Code</th>
                        <td ID="txtStockCode"></td>
                        <th scope="row">UOM</th>
                        <td colspan="3" id="txtUOM"></td>
                    </tr>
                    <tr>
                        <th scope="row">Material Name</th>
                        <td colspan="3" id="txtStockName"></td>
                        <th scope="row">Category</th>
                        <td ID="txtCategory"></td>
                    </tr>
                    <tr>
                        <th scope="row">Net Weight (KG)</th>
                        <td ID="txtNetWeight"></td>
                        <th scope="row">Gross Weight (KG)</th>
                        <td ID="txtGrossWeight"></td>

                        <th scope="row">Measurement CBM</th>
                        <td ID="txtMeasurement"></td>
                    </tr>
                    </tbody>
                </table>
                </form>
            </article>

            <article class="tap_area" id="price_info_div" style="display:none;">
                <div class="divine_auto"><!-- divine_auto start -->
                    <div style="width:50%;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Price & Value Information</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="price_info_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <form id='priceForm' name='priceForm' method='post'>
                <input type="hidden" name="priceTypeid" id="priceTypeid" value=""/>
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                        <col style="width:160px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
<!--                     <tr> -->
<!--                         <th scope="row">Cost</th> -->
<!--                         <td ID="txtCost"></td> -->
<!--                         <th scope="row">Normal Price</th> -->
<!--                         <td ID="txtNormalPrice"></td> -->
<!--                         <th scope="row">Point of Value (PV)</th> -->
<!--                         <td ID="txtPV"></td> -->
<!--                     </tr> -->
                    <tr>
                        <th scope="row">Monthly Rental</th>
                        <td ID="txtMonthlyRental"></td>
                        <th scope="row">Rental Deposit</th>
                        <td ID="txtRentalDeposit"></td>
                        <th scope="row">Penalty Charges</th>
                        <td ID="txtPenaltyCharge"></td>
                    </tr>
                    <tr>
                        <th scope="row">Trade In (PV) Value</th>
                        <td colspan="5" ID="txtTradeInPV"></td>
                    </tr>
                    
                     <tr>
                        <th scope="row">Cost</th>
                        <td colspan="5" ID="txtCost"></td>
                    </tr>
                     <tr>
                        <th scope="row">Normal Price</th>
                        <td colspan="5" ID="txtNormalPrice"></td>
                    </tr>
                    <tr>
                        <th scope="row">Point of Value (PV)</th> 
                        <td colspan="5" ID="txtPV"></td>
                    </tr>
                    </tbody>
                </table>
                </form>
                </div>
                <div style="width:1%;" >
                </div>
                <div style="width:49%;">
                
                <aside class="title_line"><!-- title_line start -->
                <h3>Price & Value Information History</h3>
                </aside><!-- title_line end -->
                
                <div id="priceHistory_div"></div>
                </div>
                
                </div><!-- divine_auto end -->
            </article>
            
            <article class="tap_area" id="filter_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                    <h3 id="filterTab">Stock's Filter List</h3>
                    <!-- <ul class="left_opt">
                    <li><p class="btn_blue"><a id="filter_info_edit">EDIT</a></p></li>
                    </ul> -->
                </aside>
                <div id="filter_grid" style="width:100%;">
                </div>                
            </article>
            <article class="tap_area" id="spare_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                    <h3>Stock's Spare Part List</h3>
                   <!--  <ul class="left_opt">
                    <li><p class="btn_blue"><a id="spare_info_edit">EDIT</a></p></li>
                    </ul> -->
                </aside>
                <div id="spare_grid" style="width:100%;"></div>
            </article>
            <article class="tap_area" id="service_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Service Charge Information List</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="service_info_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <div id="service_grid" style="width:100%;"></div>
            </article>
            <!-- service_point -->
            <article class="tap_area" id="service_point_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <h3>Service Point</h3>
                <ul class="left_opt">
                    <li><p class="btn_blue"><a id="service_point_edit">EDIT</a></p></li>
                </ul>
                </aside>
                <form id="servicepoint" name="servicepoint" method="post">
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:200px" />
                        <col style="width:*" />
                        <col style="width:200px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">A/S</th>
                        <td ID="as"></td>
                        <th scope="row">OS_A/S</th>
                        <td ID="osas"></td>
                    </tr>
                    <tr>
                        <th scope="row">H/S</th>
                        <td ID="hs"></td>
                        <th scope="row">OS_H/S</th>
                        <td id="oshs"></td>
                    </tr>
                    <tr>
                        <th scope="row">INSTALLATION</th>
                        <td id="install"></td>
                        <th scope="row">OS_INSTALLATION</th>
                        <td ID="osinstall"></td>
                    </tr>
                    </tbody>
                </table>
                </form>
            </article>
            <!-- service_point -->
            <article class="tap_area" id="stock_img_td" style="display:none;">
                <table class="type1">
                    <caption>search table</caption>
                    <colgroup>
                        <col style="width:69%" />
                        <col style="width:1%" />
                        <col style="width:30%" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <td  style="text-align: left;">
                            <div id="stock_img_div" style="width:100%;"></div></td>
                        <td >&nbsp;</td>
                        <td id="imgShow"></td>
                    </tr>
                </table>                        
            </article>
             <article class="tap_area" id="stock_commisssion_div" style="display:none;">
                 <div class="divine_auto"><!-- divine_auto start -->
                 <div style="width:50%;">
                 <aside class="title_line">
                <!-- <h3>Stock Information</h3> -->
                <ul class="right_opt">
                    <li><p class="btn_blue"><a id="stock_comm_edit" style="display: none;"><spring:message code='sys.btn.save' /></a></p></li>
                </ul> 
                </aside>
                <form id='commForm' name='commForm' method='post'>
                <!-- <input type="hidden" name="priceTypeid" id="priceTypeid" value=""/> -->
                
                <aside class="title_line"><!-- title_line start -->
                <h3>Stock Information</h3>
                </aside><!-- title_line end -->
                
                    <table class="type1">
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Stock Code</th>
                                <td ID="txtStckCd"></td>
                                <th scope="row">Category</th>
                                <td ID="txtStckCtgry"></td>
                            </tr>
                            <tr>
                                <th scope="row">Stock Name</th>
                                <td ID="txtStckNm" colspan="3"></td>
                            </tr>
                        </tbody>
                        </table>
                        
                        <aside class="title_line"><!-- title_line start -->
                        <h3>Commission Setting - Installation</h3>
                        </aside><!-- title_line end -->
                
                        <table class="type1">
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                         <tr>
                             <th scope="row">Rate</th>
                             <td ID="txtRate_install"></td>
                             <th scope="row">Outsource Rate</th>
                             <td ID="txtOutRate_install"></td>
                         </tr>
                         </tbody>
                        </table>
                        
                        <aside class="title_line"><!-- title_line start -->
                        <h3>Commission Setting - Before Service (BS)</h3>
                        </aside><!-- title_line end -->

                        <table class="type1">
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                         <tr>
                             <th scope="row">Rate</th>
                             <td ID="txtRate_bs"></td>
                             <th scope="row">Outsource Rate</th>
                             <td ID="txtOutRate_bs"></td>
                         </tr>
                         </tbody>
                        </table>
                        
                        <aside class="title_line"><!-- title_line start -->
                        <h3>Commission Setting - After Service (AS)</h3>
                        </aside><!-- title_line end -->
                         
                        <table class="type1">
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>          
                         <tr>
                             <th scope="row">Rate</th>
                             <td ID="txtRate_as"></td>
                             <th scope="row">Outsource Rate</th>
                             <td ID="txtOutRate_as"></td>
                         </tr>
                         </tbody>
                         </table>
                </form>
                            
                </div>
                </div><!-- divine_auto end -->
             </article>
        </section><!--  tab -->
    </section><!-- data body end -->


<!-- registr filter-->
<div class="popup_wrap" id="regFilterWindow" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Add Filter</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->  
            <!-- pop_body start -->
                <form id="filterForm" name="filterForm" method="POST">
                    <table class="type1">
                        <!-- table start -->
                        <caption>search table</caption>
                        <colgroup>
                            <col style="width: 150px" />
                            <col style="width: *" />
                            <col style="width: 160px" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Category</th>
                                <td colspan="3"><select id="categoryPop" name="categoryPop"
                                    onchange="getCdForStockList('filtercdPop' , this.value , 'filtercd', '')"></select></td>
                            </tr>
                            <tr>
                                <th scope="row">Filter Code</th>
                                <td colspan="3" class="w100p"><select id="filtercdPop"
                                    class="w100p" name="filtercdPop"></select></td>
                            </tr>
                            <tr>
                                <th scope="row">Filter Type</th>
                                <td colspan="3"><select id="filtertypePop">
                                        <option value="310">Default</option>
                                        <option value="311">Optional</option>
                                </select></td>
                            </tr>
                            <tr>
                                <th scope="row">Life Period</th>
                                <td colspan="2"><input type="text" id="lifeperiodPop"
                                    name="lifeperiodPop" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'/></td>
                                <td align="left">month(s)</td>
                            </tr>
                            <tr>
                                <th scope="row" rowspan="3">Quantity</th>
                                <td colspan="3"><input type="text" id="quantityPop"
                                    name="quantityPop" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'/></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                    <ul class="center_btns">
                        <li><p class="btn_blue2 big"><a onclick="javascript:addRowFileter();">SAVE</a></p></li> 
                        <li><p class="btn_blue2 big"><a onclick="javascript:cancelRowFileter();">CANCEL</a></p></li>
                    </ul>
                </form> 
    </section>  
</div>
        
        
    
    <!-- register spare part-->
<div class="popup_wrap" id="regSpareWindow" style="display:none"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Add Spare Part</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->          
    <form id="spareForm" name="spareForm" method="POST">
        <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width: 150px" />
                <col style="width: *" />
                <col style="width: 160px" />
                <col style="width: *" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Category</th>
                    <td colspan="3"><select id="categoryPop_sp" name="categoryPop_sp"
                        onchange="getCdForStockList('sparecdPop' , this.value , 'sparecd', '')"></select></td>
                </tr>
                <tr>
                    <th scope="row">Spare Part Code</th>
                    <td colspan="3" class="w100p"><select id="sparecdPop"
                        class="w100p" name="sparecdPop"></select></td>
                </tr>
                <tr>
                    <th scope="row" rowspan="3">Quantity</th>
                    <td colspan="3"><input type="text" id="quantityPop_sp"
                        name="quantityPop_sp"  onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  /></td>
                </tr>
            </tbody>
        </table>
        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a onclick="javascript:addRowSparePart();">SAVE</a></p></li> 
            <li><p class="btn_blue2 big"><a onclick="javascript:cancelRowSparePart();">CANCEL</a></p></li>
        </ul>
    </form>       
 </section>     
</div>      
        
<!-- insert into -->
<div class="popup_wrap" id="editWindow" style="display:none"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Non-Valued Item</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="insForm" name="insForm" method="POST">
<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Stock Type</th>
    <td ><select id="istockType" name="istockType" class="w100p">
            <option value="2687">Item Bank</option>
        </select>
    </td>
    <td colspan="4">
        <label><input type="checkbox" name="insSirim" id="insSirim"/><span>Sirim Certificate</span></label>
        <label><input type="checkbox" name="insNCV"   id="insNCV" /><span>NCV</span></label>
        <label><input type="checkbox" name="insas"    id="insas" /><span>ALLOW_SALES</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Stock Code</th>
    <td><input type="text" name="insStockCode" id="insStockCode" class="w100p"/></td>    
    <th scope="row">UOM</th>
    <td>
        <select id="insUom" name="insUom" class="w100p"></select>
    </td>
    <td colspan="2"></td>
</tr>
<tr>
    <th scope="row">Stock Name</th>
    <td colspan="3"><input type="text" name="istocknm" id="istocknm" class="w100p"/></td>
    <th scope="row">Category</th>
    <td><select id="insCate" name="insCate" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row" colspan="6">Price & Value Information</th>    
</tr>
<tr>
    <th scope="row">Old Material Number</th>
    <td colspan="3"><input type="text" name="oldStockNo" id="oldStockNo" class="w100p"/></td>
    <td colspan="2"></td>
</tr>
<tr>
    <th scope="row">Net Weight (KG)</th>
    <td><input type="text" id="insnw" name="insgw" class="w100p" value="" disabled=true/></td>
    <th scope="row">Gross Weight (KG)</th>
    <td><input type="text" id="insgw" name="insgw" class="w100p" value="" disabled=true/></td>
    <th scope="row">Measurement CBM</th>
    <td><input type="text" id="insmscbm" name="insmscbm" class="w100p" value="" disabled=true/></td>
</tr>

<tr>
    <th scope="row">Cost</th>
    <td><input type="text" id="inscost" name="inscost" class="w100p" value="" disabled=true/></td>
    <th scope="row">Normal Price</th>
    <td><input type="text" id="insnp" name="insnp" class="w100p" value=""/></td>
    <th scope="row">Point of Value(PV)</th>
    <td><input type="text" id="inspov" name="inspov" class="w100p" value="" disabled=true/></td>
</tr>
<tr>
    <th scope="row">Monthly Rental</th>
    <td><input type="text" id="insmr" name="insmr" class="w100p" value="" disabled=true/></td>
    <th scope="row">Rental Deposit</th>
    <td><input type="text" id="insrd" name="insrd" class="w100p" value="" disabled=true/></td>
    <th scope="row">Penalty Charges</th>
    <td><input type="text" id="inspc" name="inspc" class="w100p" value="" disabled=true/></td>
</tr>
<tr>
    <th scope="row">Trade In (PV) Value</th>
    <td colspan="3"><input type="text" id="insti" name="insti" class="w100p" value="" disabled=true/></td>
    <td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_nonvalueItem('1');">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_nonvalueItem('2');">CANCEL</a></p></li>
</ul>
</form>

</section>
</div>
        
    </section><!-- content end -->
</div>


