import 'package:flutter/material.dart';
import 'package:syv_ui/syv_ui.dart';

/// Living specimen of the "Diseño Verde" design system. Opens with the SyV logo
/// and walks every component top→bottom, mirroring the reference web showcase.
class ShowcaseView extends StatefulWidget {
  /// Creates the showcase screen.
  const ShowcaseView({super.key});

  @override
  State<ShowcaseView> createState() => _ShowcaseViewState();
}

class _ShowcaseViewState extends State<ShowcaseView> {
  // Interactive demo state.
  final TextEditingController _inputCtrl = TextEditingController(
    text: 'damián diconte',
  );
  final TextEditingController _notaCtrl = TextEditingController(
    text: 'damián diconte llegó a dársena con una orden sellada y ninguna '
        'intención de cumplirla al pie de la letra.',
  );
  bool _sw1 = true;
  bool _sw2 = false;
  bool _sw3 = true;
  int _cuerpo = 5;
  int _mente = 4;
  int _alma = 6;

  @override
  void dispose() {
    _inputCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SyvColors.ink1000,
      body: SyvGlow(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  SyvSpace.xxl,
                  SyvSpace.s5,
                  SyvSpace.xxl,
                  SyvSpace.s7,
                ),
                children: <Widget>[
                  // (0) intro
                  const SyvLogo(size: SyvLogoSize.lg),
                  const SizedBox(height: SyvSpace.s5),
                  const SyvKicker(
                    num: '00',
                    child: Text('PRESENTATION KIT · CLANDESTINO'),
                  ),
                  const SizedBox(height: SyvSpace.md),
                  Text('diseño verde', style: SyvType.display),
                  const SizedBox(height: SyvSpace.md),
                  Text(
                    'sistema de diseño verde mate militar de subordinación y '
                    'valor. profundidad por glow, hairline y radio — nunca '
                    'sombra. cada pieza vive acá abajo.',
                    style: SyvType.body,
                  ),

                  // (1) logo variants
                  SyvSection(num: '01', title: 'logo'),
                  const SyvLogo(
                    variant: SyvLogoVariant.militar,
                    size: SyvLogoSize.md,
                  ),
                  const SizedBox(height: SyvSpace.lg),
                  const SyvLogo(
                    variant: SyvLogoVariant.argentina,
                    size: SyvLogoSize.md,
                  ),
                  const SizedBox(height: SyvSpace.lg),
                  const SyvLogo(
                    variant: SyvLogoVariant.clerical,
                    size: SyvLogoSize.md,
                  ),

                  // (2) buttons
                  SyvSection(num: '02', title: 'botones'),
                  _wrap(<Widget>[
                    for (final c in SyvAccent.values)
                      SyvButton(label: c.name, color: c, onPressed: () {}),
                  ]),
                  const SizedBox(height: SyvSpace.md),
                  _wrap(<Widget>[
                    SyvButton(label: 'primary', onPressed: () {}),
                    SyvButton(
                      label: 'secondary',
                      variant: SyvButtonVariant.secondary,
                      onPressed: () {},
                    ),
                    SyvButton(
                      label: 'ghost',
                      variant: SyvButtonVariant.ghost,
                      onPressed: () {},
                    ),
                    SyvButton(label: 'mono', mono: true, onPressed: () {}),
                    SyvButton(
                      label: 'sm',
                      size: SyvButtonSize.sm,
                      onPressed: () {},
                    ),
                    const SyvButton(label: 'disabled', disabled: true),
                  ]),

                  // (3) chips
                  SyvSection(num: '03', title: 'chips'),
                  _wrap(<Widget>[
                    for (final t in SyvChipTone.values)
                      SyvChip(label: t.name, tone: t, dot: true),
                  ]),

                  // (4) cards
                  SyvSection(num: '04', title: 'cards'),
                  for (final v in SyvCardVariant.values) ...<Widget>[
                    SyvCard(
                      variant: v,
                      glow: v == SyvCardVariant.emphasis,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(v.name, style: SyvType.title),
                          const SizedBox(height: SyvSpace.sm),
                          Text(
                            'fondo negro puro; la luz la trae la variante.',
                            style: SyvType.body,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SyvSpace.lg),
                  ],

                  // (5) inputs
                  SyvSection(num: '05', title: 'inputs'),
                  SyvInput(
                    label: 'nombre',
                    hint: 'campo máquina de escribir',
                    controller: _inputCtrl,
                  ),
                  const SizedBox(height: SyvSpace.xl),
                  const SyvInput(
                    label: 'rango',
                    placeholder: 'sargento primero…',
                  ),
                  const SizedBox(height: SyvSpace.xl),
                  const SyvInput(
                    label: 'clave',
                    value: 'xxx',
                    invalid: true,
                    hint: 'credencial inválida',
                  ),
                  const SizedBox(height: SyvSpace.xl),
                  const SyvInput(
                    label: 'sellado',
                    value: 'bloqueado',
                    disabled: true,
                  ),

                  // (6) switches
                  SyvSection(num: '06', title: 'switches'),
                  SyvSwitch(
                    checked: _sw1,
                    color: SyvAccent.olive,
                    label: 'olivo · activo',
                    onChanged: (v) => setState(() => _sw1 = v),
                  ),
                  const SizedBox(height: SyvSpace.md),
                  SyvSwitch(
                    checked: _sw2,
                    color: SyvAccent.celeste,
                    label: 'celeste · institucional',
                    onChanged: (v) => setState(() => _sw2 = v),
                  ),
                  const SizedBox(height: SyvSpace.md),
                  SyvSwitch(
                    checked: _sw3,
                    color: SyvAccent.amber,
                    label: 'ámbar · herramienta',
                    onChanged: (v) => setState(() => _sw3 = v),
                  ),
                  const SizedBox(height: SyvSpace.md),
                  const SyvSwitch(
                    checked: true,
                    color: SyvAccent.teal,
                    label: 'deshabilitado',
                    disabled: true,
                  ),

                  // (7) stats
                  SyvSection(num: '07', title: 'stats'),
                  SyvStat(
                    stat: SyvStatKind.cuerpo,
                    value: _cuerpo,
                    editable: true,
                    onChanged: (v) => setState(() => _cuerpo = v),
                  ),
                  const SizedBox(height: SyvSpace.lg),
                  SyvStat(
                    stat: SyvStatKind.mente,
                    value: _mente,
                    editable: true,
                    onChanged: (v) => setState(() => _mente = v),
                  ),
                  const SizedBox(height: SyvSpace.lg),
                  SyvStat(
                    stat: SyvStatKind.alma,
                    value: _alma,
                    editable: true,
                    onChanged: (v) => setState(() => _alma = v),
                  ),
                  const SizedBox(height: SyvSpace.lg),
                  // sin botones — solo lectura, los tres atributos
                  const SyvStat(stat: SyvStatKind.cuerpo, value: 5),
                  const SizedBox(height: SyvSpace.lg),
                  const SyvStat(stat: SyvStatKind.mente, value: 4),
                  const SizedBox(height: SyvSpace.lg),
                  const SyvStat(stat: SyvStatKind.alma, value: 6),

                  // (8) statbtn — tres botones en línea
                  SyvSection(
                    num: '08',
                    title: 'statbtn · cuerpo · mente · alma en una línea',
                  ),
                  const SyvStatBtnRow(cuerpo: 5, mente: 4, alma: 6),

                  // (9) textarea — multilínea, ancho de pantalla, sin marco
                  SyvSection(num: '09', title: 'textarea'),
                  SyvTextarea(
                    label: 'nota',
                    hint: 'escritura larga · crece y luego scrollea',
                    controller: _notaCtrl,
                  ),
                  const SizedBox(height: SyvSpace.xl),
                  const SyvTextarea(
                    label: 'informe',
                    placeholder: 'redactar parte de situación…',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrap(List<Widget> children) {
    return Wrap(
      spacing: SyvSpace.sm,
      runSpacing: SyvSpace.sm,
      children: children,
    );
  }
}
