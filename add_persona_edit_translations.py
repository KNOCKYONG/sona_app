import json
import os

# Translation data for all 21 languages
translations = {
    'en': {
        'editPersona': 'Edit Persona',
        'personaUpdated': 'Persona updated successfully',
        'cannotEditApprovedPersona': 'Approved personas cannot be edited',
        'update': 'Update'
    },
    'ko': {
        'editPersona': '페르소나 수정',
        'personaUpdated': '페르소나가 성공적으로 업데이트되었습니다',
        'cannotEditApprovedPersona': '승인된 페르소나는 수정할 수 없습니다',
        'update': '업데이트'
    },
    'ja': {
        'editPersona': 'ペルソナを編集',
        'personaUpdated': 'ペルソナが正常に更新されました',
        'cannotEditApprovedPersona': '承認されたペルソナは編集できません',
        'update': '更新'
    },
    'zh': {
        'editPersona': '编辑人格',
        'personaUpdated': '人格已成功更新',
        'cannotEditApprovedPersona': '已批准的人格无法编辑',
        'update': '更新'
    },
    'th': {
        'editPersona': 'แก้ไขเพอร์โซน่า',
        'personaUpdated': 'อัปเดตเพอร์โซน่าสำเร็จ',
        'cannotEditApprovedPersona': 'ไม่สามารถแก้ไขเพอร์โซน่าที่ได้รับการอนุมัติแล้ว',
        'update': 'อัปเดต'
    },
    'vi': {
        'editPersona': 'Chỉnh sửa Persona',
        'personaUpdated': 'Cập nhật Persona thành công',
        'cannotEditApprovedPersona': 'Không thể chỉnh sửa Persona đã được phê duyệt',
        'update': 'Cập nhật'
    },
    'id': {
        'editPersona': 'Edit Persona',
        'personaUpdated': 'Persona berhasil diperbarui',
        'cannotEditApprovedPersona': 'Persona yang telah disetujui tidak dapat diedit',
        'update': 'Perbarui'
    },
    'tl': {
        'editPersona': 'I-edit ang Persona',
        'personaUpdated': 'Matagumpay na na-update ang Persona',
        'cannotEditApprovedPersona': 'Hindi maaaring i-edit ang mga aprubadong Persona',
        'update': 'I-update'
    },
    'es': {
        'editPersona': 'Editar Persona',
        'personaUpdated': 'Persona actualizada con éxito',
        'cannotEditApprovedPersona': 'Las personas aprobadas no se pueden editar',
        'update': 'Actualizar'
    },
    'fr': {
        'editPersona': 'Modifier le Persona',
        'personaUpdated': 'Persona mis à jour avec succès',
        'cannotEditApprovedPersona': 'Les personas approuvés ne peuvent pas être modifiés',
        'update': 'Mettre à jour'
    },
    'de': {
        'editPersona': 'Persona bearbeiten',
        'personaUpdated': 'Persona erfolgreich aktualisiert',
        'cannotEditApprovedPersona': 'Genehmigte Personas können nicht bearbeitet werden',
        'update': 'Aktualisieren'
    },
    'ru': {
        'editPersona': 'Редактировать персону',
        'personaUpdated': 'Персона успешно обновлена',
        'cannotEditApprovedPersona': 'Одобренные персоны нельзя редактировать',
        'update': 'Обновить'
    },
    'pt': {
        'editPersona': 'Editar Persona',
        'personaUpdated': 'Persona atualizada com sucesso',
        'cannotEditApprovedPersona': 'Personas aprovadas não podem ser editadas',
        'update': 'Atualizar'
    },
    'it': {
        'editPersona': 'Modifica Persona',
        'personaUpdated': 'Persona aggiornata con successo',
        'cannotEditApprovedPersona': 'Le personas approvate non possono essere modificate',
        'update': 'Aggiorna'
    },
    'nl': {
        'editPersona': 'Persona bewerken',
        'personaUpdated': 'Persona succesvol bijgewerkt',
        'cannotEditApprovedPersona': 'Goedgekeurde personas kunnen niet worden bewerkt',
        'update': 'Bijwerken'
    },
    'sv': {
        'editPersona': 'Redigera Persona',
        'personaUpdated': 'Persona uppdaterad framgångsrikt',
        'cannotEditApprovedPersona': 'Godkända personas kan inte redigeras',
        'update': 'Uppdatera'
    },
    'pl': {
        'editPersona': 'Edytuj Personę',
        'personaUpdated': 'Persona zaktualizowana pomyślnie',
        'cannotEditApprovedPersona': 'Zatwierdzone persony nie mogą być edytowane',
        'update': 'Aktualizuj'
    },
    'tr': {
        'editPersona': 'Persona Düzenle',
        'personaUpdated': 'Persona başarıyla güncellendi',
        'cannotEditApprovedPersona': 'Onaylanmış personalar düzenlenemez',
        'update': 'Güncelle'
    },
    'ar': {
        'editPersona': 'تحرير الشخصية',
        'personaUpdated': 'تم تحديث الشخصية بنجاح',
        'cannotEditApprovedPersona': 'لا يمكن تحرير الشخصيات المعتمدة',
        'update': 'تحديث'
    },
    'hi': {
        'editPersona': 'पर्सोना संपादित करें',
        'personaUpdated': 'पर्सोना सफलतापूर्वक अपडेट किया गया',
        'cannotEditApprovedPersona': 'अनुमोदित पर्सोना संपादित नहीं किए जा सकते',
        'update': 'अपडेट करें'
    },
    'ur': {
        'editPersona': 'پرسونا میں ترمیم کریں',
        'personaUpdated': 'پرسونا کامیابی سے اپ ڈیٹ ہوا',
        'cannotEditApprovedPersona': 'منظور شدہ پرسونا میں ترمیم نہیں کی جا سکتی',
        'update': 'اپ ڈیٹ'
    }
}

def add_persona_edit_translations():
    """Add persona edit-related translations to all language files"""
    
    base_dir = 'sona_app/lib/l10n'
    
    for lang_code, trans in translations.items():
        file_path = os.path.join(base_dir, f'app_{lang_code}.arb')
        
        if not os.path.exists(file_path):
            print(f"Warning: File not found: {file_path}")
            continue
            
        # Read the existing file
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        try:
            data = json.loads(content)
        except json.JSONDecodeError as e:
            print(f"Error parsing {file_path}: {e}")
            continue
        
        # Check if keys already exist
        updated = False
        for key, value in trans.items():
            if key not in data:
                data[key] = value
                data[f'@{key}'] = {
                    'description': f'Localized string for {key}'
                }
                updated = True
                print(f"[ADDED] {lang_code}: {key}")
            else:
                print(f"[EXISTS] {lang_code}: {key}")
        
        if updated:
            # Write back
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"[UPDATED] {lang_code}: File updated")
        else:
            print(f"[OK] {lang_code}: All keys already exist")

if __name__ == '__main__':
    add_persona_edit_translations()
    print("\n[COMPLETE] Persona edit translations added to all language files!")
    print("Now run: flutter gen-l10n")