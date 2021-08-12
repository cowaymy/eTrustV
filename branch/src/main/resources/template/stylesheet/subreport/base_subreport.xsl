<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://ws.cmctos.com.my/ctosnet/response"
                exclude-result-prefixes="xsl r">
    
    <!-- start css -->
    <xsl:template name="css_template">
        
        <!-- start media -->
        @media screen, print, projection {
                    
        <!-- start css base layout -->
        * {font-family: Helvetica,Arial,sans-serif; margin: 0px; border-spacing: 0px; padding: 0px; }
        body {margin: auto; width: 650px;}
        div {font-size: 8pt;}
        <!-- finish css base layout -->

        <!-- start css standard layout -->
        .title {color: #FFFFFF; background-color: #007A85; border: 1px solid #000000; font-size: 8pt; font-weight: bold; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .header {color: #FFFFFF; background-color: #666666; border: 1px solid #000000; font-size: 8pt; font-weight: bold; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .sub-header {color: #FFFFFF; background-color: #666666; border: 1px solid #000000; font-size: 8pt; font-weight: bold; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .caption {color: #000000; background-color: #DDDDDD; width: 20%; word-wrap: break-word;}        
        .header {color: #FFFFFF; background: #666666; border: 1px solid #000000; font-size: 8pt; font-weight: bold; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .info {border: 1px solid #000000; padding: 2px 10px 2px 10px; font-size: 8pt; vertical-align: middle; text-indent: 0px; word-wrap: break-word;}
        .info-no-style {padding: 2px 10px 2px 10px; font-size: 8pt; vertical-align: middle; text-indent: 0px; word-wrap: break-word;}
        .notice {text-align: justify; border: 1px solid #000000; vertical-align: middle; font-size: 6pt; font-style: italic; padding: 2px 10px 2px 10px; text-indent: 0px; word-wrap: break-word;}
        <!-- finish css standard layout -->

        <!-- start table layout -->
        .table, .table-id-verification, .table-text-center, .table-text-right {font-size: 8pt; width: 100%; border-collapse: collapse;}
        .table th {text-align: left; background-color: #DDDDDD; border: 1px solid #000000; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .table td {border: 1px solid #000000; padding: 2px 10px 2px 10px; vertical-align: middle;}

        .table-text-center th {background-color: #DDDDDD; text-align: center; border: 1px solid #000000; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .table-text-center td {text-align: center; border: 1px solid #000000; padding: 2px 10px 2px 10px; vertical-align: middle;}

        .table-text-right th {background-color: #DDDDDD; text-align: right; border: 1px solid #000000; padding: 2px 10px 2px 10px; vertical-align: middle;}
        .table-text-right td {text-align: right; border: 1px solid #000000; padding: 2px 10px 2px 10px; vertical-align: middle;}

        .table-left-width {width: 64%; text-align: left;}
        .table-center-width {width: 2%;}
        .table-right-width {width: 34%; text-align: center;}
        <!-- finish table layout -->

        <!-- start table header layout -->
        .table-header-left {font-size: 5pt; width: 100%; padding: 2px 0px 2px 0px; vertical-align: middle;}
        .table-header-left th {text-align: left;}
        .table-header-left td {text-align: justify;}

        .table-header-right {font-size: 14pt; width: 100%; padding: 2px 0px 2px 0px; vertical-align: middle;}
        .table-header-right th {text-align: right; font-weight: bold;}
        <!-- finish table header layout -->

        <!-- start table id verification layout -->
        .table-id-verification th {vertical-align: top;}
        .table-id-verification td {vertical-align: top;}
        <!-- finish table id verification layout -->

        <!-- start id table stats layout -->
        .table-stats {font-size: 5pt; width: 100%; border: 1px solid #000000; border-collapse: collapse;}
        .table-stats th {border: 1px solid #000000; background-color: #DDDDDD; padding: 2px 2px 2px 2px; vertical-align: middle; text-align: center;}
        .table-stats td {border: 1px solid #000000; padding: 2px 2px 2px 2px; vertical-align: middle;}
        <!-- finish table stats layout -->

        <!-- start table ccris layout -->
        .table-ccris {font-size: 5pt; width: 100%; border-collapse: collapse;}
        .table-ccris th {background-color: #DDDDDD; text-align: center; border: 1px solid #000000; vertical-align: middle;}
        .table-ccris td {text-align: center; border: 1px solid #000000; vertical-align: middle;}
        <!-- finish table ccris layout -->        

        <!-- start css custom style -->
        .caption-left {color: #000000; background-color: #DDDDDD; width: 45%; word-wrap: break-word;}

        .short-content {width: 30%; word-wrap: break-word;}
        .long-content {width: 80%; word-wrap: break-word;}
        .long-content-left {width: 55%; word-wrap: break-word;}

        .text-center {text-align: center;}
        .text-left {text-align: left;}
        .text-right {text-align: right;}

        .vertical-center {vertical-align: middle;}
        
        .bold {font-weight: bold;}
            
        .separator {padding: 2px 0px 2px 0px; border: 1px solid #000000;}
        <!-- finish css custom style -->
        
        }
        <!-- finish media -->
        
    </xsl:template>
    <!-- finish css -->
    
    <!-- start check empty and format currency -->
    <xsl:template name="check_empty_and_format_currency">
        <xsl:param name="value"/>
        <xsl:if test="not($value) or $value = ''">-</xsl:if>
        <xsl:if test="$value and $value != ''">
            <xsl:value-of select="format-number(translate($value, ',', ''), '###,##0.00')"/>
        </xsl:if>
    </xsl:template>
    <!-- finish check empty and format currency -->
    
    <!-- start convert value to boolean -->
    <xsl:template name="convert_value_to_boolean">
        <xsl:param name="value"/>
        <xsl:if test="not($value) or $value = ''">-</xsl:if>
        <xsl:if test="$value and $value != ''">
            <xsl:if test="$value != '1'">
                NOT SELECTED
            </xsl:if>
            <xsl:if test="$value = '1'">
                YES
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!-- finish convert value to boolean -->
    
    <!-- start convert value to boolean1 -->
    <xsl:template name="convert_value_to_boolean1">
        <xsl:param name="value"/>
        <xsl:if test="not($value) or $value = ''">NO</xsl:if>
        <xsl:if test="$value and $value != ''">
            <xsl:if test="$value != '1'">
                NO
            </xsl:if>
            <xsl:if test="$value = '1'">
                YES
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!-- finish convert value to boolean1 -->
    
    <!-- start convert value to boolean2 -->
    <xsl:template name="convert_value_to_boolean2">
        <xsl:param name="value"/>
        <xsl:if test="not($value) or $value = ''">-</xsl:if>
        <xsl:if test="$value and $value != ''">
            <xsl:if test="$value != '1'">
                NO
            </xsl:if>
            <xsl:if test="$value = '1'">
                YES
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!-- finish convert value to boolean2 -->
    
    <!-- start check null -->
    <xsl:template name="check_null">
        <xsl:param name="value"/>
        <xsl:if test="not($value) or $value = ''">NO</xsl:if>
        <xsl:if test="$value and $value != ''">
            <xsl:value-of select="$value"/>
        </xsl:if>
    </xsl:template>
    <!-- finish check null -->
    
    <!-- start check empty string -->
    <xsl:template name="check_empty_string">
        <xsl:param name="value"/>
        <xsl:if test="not($value) or translate($value, ' ', '') = ''">-</xsl:if>
        <xsl:if test="$value and translate($value, ' ', '') != ''">
            <xsl:value-of select="$value"/>
        </xsl:if>
    </xsl:template>
    <!-- finish check empty string -->
    
    <!-- start check empty integer -->
    <xsl:template name="check_empty_integer">
        <xsl:param name="integer"/>
        <xsl:if test="not($integer) or $integer = ''">0</xsl:if>
        <xsl:if test="$integer and $integer != ''">
            <xsl:value-of select="$integer"/>
        </xsl:if>
    </xsl:template>
    <!-- finish check empty integer -->
    
    <!-- start check empty number -->
    <xsl:template name="check_empty_number">
        <xsl:param name="number"/>
        <xsl:if test="not($number) or $number = ''">0.00</xsl:if>
        <xsl:if test="$number and $number != ''">
            <xsl:choose>
                <xsl:when test="format-number(translate($number, ',', ''), '###,##0.00') != 'NaN'">
                    <xsl:value-of select="format-number(translate($number, ',', ''), '###,##0.00')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$number"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!-- finish check empty number -->
    
    <!-- start check empty number no zero -->
    <xsl:template name="check_empty_number_no_zero">
        <xsl:param name="number"/>
        <xsl:if test="not($number) or $number = '' or $number = '0'">-</xsl:if>
        <xsl:if test="$number and $number != '' and $number != '0'">
            <xsl:value-of select="format-number(translate($number, ',', ''), '###,##0.00')"/>
        </xsl:if>
    </xsl:template>
    <!-- finish check empty number no zero -->
    
    <!-- start check NaN -->
    <xsl:template name="checkNaN">
        <xsl:param name="number"/>
        <xsl:choose>
            <xsl:when test="string(number($number)) != 'NaN'">
                <xsl:value-of select="format-number(translate($number, ',', ''), '###,##0.00')"/>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    <!-- finish check NaN -->
    
    <xsl:template name="calcYoY">
        <xsl:param name="num1" />
        <xsl:param name="num2" />
        <xsl:variable name="output">
            <xsl:value-of select="($num1 - $num2) div $num2 * 100" />
        </xsl:variable>
        <xsl:variable name="value2">
            <xsl:choose>
                <xsl:when test="string-length($num2) &gt; 0">
                    <xsl:variable name = "chkNumber" select = "translate($num2, ',', '')" />
                    <xsl:choose>
                        <xsl:when test="number($chkNumber) = $chkNumber">
                            <xsl:value-of select="$chkNumber" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$output != 'NaN'">
                <xsl:value-of select="concat(format-number(translate($output, ',', ''),'##,##0.00'),'%')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'-'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="calcShareholding">
        <xsl:param name="num1" />
        <xsl:param name="num2" />
        <xsl:variable name="output">
            <xsl:if test="$num1 and $num1 != '' and $num2 and $num2 != ''">
                <xsl:value-of select="($num1 div $num2) * 100" />
            </xsl:if>
            <xsl:if test="not($num1) or $num1 = '' or not($num2) or $num2 = ''">
                <xsl:value-of select="'NaN'" />
            </xsl:if>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$output != 'NaN'">
                <xsl:value-of select="format-number(translate($output, ',', ''),'#0')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'-'" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- start custom month_name -->
    <xsl:template name="month_name_template">
        <xsl:param name="month"/>
        <xsl:if test="$month = 1">January</xsl:if>
        <xsl:if test="$month = 2">February</xsl:if>
        <xsl:if test="$month = 3">March</xsl:if>
        <xsl:if test="$month = 4">April</xsl:if>
        <xsl:if test="$month = 5">May</xsl:if>
        <xsl:if test="$month = 6">June</xsl:if>
        <xsl:if test="$month = 7">July</xsl:if>
        <xsl:if test="$month = 8">August</xsl:if>
        <xsl:if test="$month = 9">September</xsl:if>
        <xsl:if test="$month = 10">October</xsl:if>
        <xsl:if test="$month = 11">November</xsl:if>
        <xsl:if test="$month = 12">December</xsl:if>
    </xsl:template>
    <!-- finish custom month_name -->
    
    <!-- start custom month_abbreviation -->
    <xsl:template name="month_abbreviation_template">
        <xsl:param name="month"/>
        <xsl:if test="$month = 1">Jan</xsl:if>
        <xsl:if test="$month = 2">Feb</xsl:if>
        <xsl:if test="$month = 3">Mar</xsl:if>
        <xsl:if test="$month = 4">Apr</xsl:if>
        <xsl:if test="$month = 5">May</xsl:if>
        <xsl:if test="$month = 6">Jun</xsl:if>
        <xsl:if test="$month = 7">Jul</xsl:if>
        <xsl:if test="$month = 8">Aug</xsl:if>
        <xsl:if test="$month = 9">Sep</xsl:if>
        <xsl:if test="$month = 10">Oct</xsl:if>
        <xsl:if test="$month = 11">Nov</xsl:if>
        <xsl:if test="$month = 12">Dec</xsl:if>    
    </xsl:template>
    <!-- finish custom month_abbreviation -->
    
    <!-- start individual record type index -->
    <xsl:template name="individual_record_type_index">
        <xsl:param name="index"/>
        <xsl:if test="$index = '99'">Subject deceased</xsl:if>
        <xsl:if test="$index = '98'">Mismatch of name to ID (new IC match , name Not match)</xsl:if>
        <xsl:if test="$index = '97'">Mismatch of name to ID (new IC match , name Not match)</xsl:if>
        <xsl:if test="$index = '95'">Bankcrupty receiving or adjudication order issued</xsl:if>
        <xsl:if test="$index = '93'">Bankcruptcy creditors petition issued</xsl:if>
        <xsl:if test="$index = '91'">Bankruptcy notice issued</xsl:if>
        <xsl:if test="$index = '89'">Proclamation of sale under deed of assignment</xsl:if>
        <xsl:if test="$index = '88'">Proclamation of sale under the national land code or foreclosure proceedings - originating summons issued</xsl:if>
        <xsl:if test="$index = '87'">Civil suit, summon</xsl:if>
        <xsl:if test="$index = '85'">Tribunal</xsl:if>
        <xsl:if test="$index = '83'">Internal / Special listing - AMLA</xsl:if>
        <xsl:if test="$index = '82'">Internal / Special listing - Internal lists</xsl:if>    
        <xsl:if test="$index = '81'">Internal / Special listing - KLSE defaulter</xsl:if>    
        <xsl:if test="$index = '49'">AO discharged / annulment</xsl:if>    
        <xsl:if test="$index = '48'">CP struck off / Action withdrawn / settled</xsl:if>    
        <xsl:if test="$index = '47'">BN struck off / Action withdrawn / settled</xsl:if>    
        <xsl:if test="$index = '45'">PS struck off / Action withdrawn / settled</xsl:if>    
        <xsl:if test="$index = '43'">CS struck off / Action withdrawn / settled</xsl:if>    
        <xsl:if test="$index = '41'">CS under repayment scheme</xsl:if>    
        <xsl:if test="$index = '39'">CS - Account regularized</xsl:if>    
        <xsl:if test="$index = '37'">Tribunal struck off / action withdrawn / settled</xsl:if>    
        <xsl:if test="$index = '25'">Director with wound up order issued</xsl:if>    
        <xsl:if test="$index = '24'">Director with company petition winding up</xsl:if>    
        <xsl:if test="$index = '23'">Director with company voluntary wound up</xsl:if>    
        <xsl:if test="$index = '21'">Director with company struck off under sec 308</xsl:if>    
        <xsl:if test="$index = '00'">Clean</xsl:if>    
        <xsl:if test="$index = '--'">Unknown</xsl:if>    
    </xsl:template>
    <!-- finish individual record type index -->
    
    <!-- start company record type index -->
    <xsl:template name="company_record_type_index">
        <xsl:param name="index"/>
        <xsl:if test="$index = '98'">Significant mismatch of company name with business registration number</xsl:if>
        <xsl:if test="$index = '97'">Company struck off / Business de-register</xsl:if>
        <xsl:if test="$index = '96'">Voluntary winding up</xsl:if>
        <xsl:if test="$index = '95'">Wound up order issued</xsl:if>
        <xsl:if test="$index = '93'">Petition for winding up</xsl:if>
        <xsl:if test="$index = '89'">Proclamation of sale under deed of assignment</xsl:if>
        <xsl:if test="$index = '88'">Proclamation of sale under the national land code or foreclosure proceedings - originating summons issued</xsl:if>
        <xsl:if test="$index = '87'">Civil suit, summon</xsl:if>
        <xsl:if test="$index = '86'">Originating summons</xsl:if>
        <xsl:if test="$index = '85'">Tribunal</xsl:if>
        <xsl:if test="$index = '83'">Internal / Special listing</xsl:if> 
        <xsl:if test="$index = '49'">Wound up order stuck off / Stayed</xsl:if>    
        <xsl:if test="$index = '48'">Petition stayed struck off / Action withdrawn / Settled</xsl:if>    
        <xsl:if test="$index = '47'">PS struck off / Action withdrawn / Settled</xsl:if>    
        <xsl:if test="$index = '45'">CS struck off / Action withdrawn / Settled</xsl:if>    
        <xsl:if test="$index = '43'">CS under repayment scheme</xsl:if>    
        <xsl:if test="$index = '41'">CS - Account regularized</xsl:if>    
        <xsl:if test="$index = '39'">Tribunal struck off / Action withdrawn / Settled</xsl:if>    
        <xsl:if test="$index = '37'">Company under special administration</xsl:if>    
        <xsl:if test="$index = '35'">Company restructure / Equity reduction</xsl:if>
        <xsl:if test="$index = '00'">Clean</xsl:if>    
        <xsl:if test="$index = '--'">Unknown</xsl:if>    
    </xsl:template>
    <!-- finish company record type index -->
    
    <!-- start weightage index -->
    <xsl:template name="weightage_index">
        <xsl:param name="index"/>
        <xsl:if test="$index = '9'">0 - 12 months</xsl:if>
        <xsl:if test="$index = '8'">13 months - 24 months</xsl:if>
        <xsl:if test="$index = '7'">25 months - 36 months</xsl:if>
        <xsl:if test="$index = '6'">37 months - 48 months</xsl:if>
        <xsl:if test="$index = '5'">49 months - 60 months</xsl:if>
        <xsl:if test="$index = '4'">61 months - 72 months</xsl:if>
        <xsl:if test="$index = '3'">73 months - 84 months</xsl:if>
        <xsl:if test="$index = '2'">85 months- 96 months</xsl:if>
        <xsl:if test="$index = '1'">> 96 months</xsl:if>
        <xsl:if test="$index = '0'">Not applicable</xsl:if>
        <xsl:if test="$index = '-'">Not applicable</xsl:if>    
    </xsl:template>
    <!-- finish weightage index -->
    
    <!-- start weightage settlement index -->
    <xsl:template name="weightage_settlement_index">
        <xsl:param name="index"/>
        <xsl:if test="$index = '7'">Most recent settlement was 12 months ago</xsl:if>
        <xsl:if test="$index = '6'">Most recent settlement was 24 months ago</xsl:if>
        <xsl:if test="$index = '5'">Most recent settlement was 36 months ago</xsl:if>
        <xsl:if test="$index = '4'">Most recent settlement was 48 months ago</xsl:if>
        <xsl:if test="$index = '3'">Most recent settlement was 60 months ago</xsl:if>
        <xsl:if test="$index = '2'">Most recent settlement was 72 months ago</xsl:if>
        <xsl:if test="$index = '1'">Most recent settlement was 84 months ago</xsl:if>
        <xsl:if test="$index = '0'">Not applicable</xsl:if>
        <xsl:if test="$index = '-'">Not applicable</xsl:if>    
    </xsl:template>
    <!-- finish weightage settlement index -->
    
    <!-- start image_template -->
    <xsl:template name="image_template">
        <xsl:param name="image"/>
        <xsl:value-of select="concat('http://enq.cmctos.com.my:8803/images/report/', $image)"/>
        <!--<xsl:value-of select="concat('/home/james/NetBeansProjects/xslt/trunk/src/java/my/com/cmctos/xslt/xsl/images/', $image)"/>-->
    </xsl:template>
    <!-- finish image_template -->
    
</xsl:stylesheet>